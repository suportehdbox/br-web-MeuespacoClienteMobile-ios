//
//  CaseViewController.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 26/07/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import UIKit

public class CaseViewController: DirectAssistViewController {

    static let identifier = "CaseViewController"

    var automotiveCase: AutomotiveCase?

    @IBOutlet weak var assistenciaValueLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var arrivePreviewLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var liveMapButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!

    @IBOutlet weak var plateLabelTitle: UILabel!
    @IBOutlet weak var arrivePreviewTitle: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading{
            self.title = "Acompanhar Assitência"
        
            self.arrivePreviewHidden(value: true)
            self.plateHidden(value: true)
            self.liveMapButton.isHidden = true

            
            self.getDispatchStatus()
        }
            
    }
    
    @IBAction func actionOpenLiveMap(_ sender: Any) {
        let liveMapScreen = DirectAssistRouter.liveHelpMapScreen()
        liveMapScreen.caseNumber = self.automotiveCase?.caseNumber
        self.navigationController?.pushViewController(liveMapScreen, animated: true)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        self.showLoading{
            self.arrivePreviewHidden(value: true)
            self.plateHidden(value: true)
            self.liveMapButton.isHidden = true
            
            self.getDispatchStatus()
        }
    }

    func getDispatchStatus(){
        let api = GetDispatchStatusServer()
        let requestObject = GetDispatchStatusRequest()
        requestObject.caseNumber = self.automotiveCase!.caseNumber!
        api.doCall(requestObject: requestObject,
                   success: {response in
                        self.assistenciaValueLabel.text = response.caseNumber
                        self.statusValueLabel.text = self.resolveDispatchStatus(status: response.dispatchStatus!, scheduled: response.scheduled == "1")
                        if (response.scheduled == "0"){
                            if (response.dispatchStatus! != "0"){
                                if (response.arrivalTime != nil && response.arrivalTime != ""){
                                    self.arrivePreviewHidden(value: false)
                                    self.arrivePreviewLabel.text = response.arrivalTime! + "minutos"
                                }
                            
                                if (response.licenseNumber != nil && response.licenseNumber != ""){
                                    self.plateHidden(value: false)
                                    self.plateLabel.text = response.licenseNumber
                                }
                            
                                if ((response.providerLatitude != nil && response.providerLatitude != "") && (response.providerLongitude != nil && response.providerLongitude != "")){
                                    self.liveMapButton.isHidden = false
                                }
                            }
                        }
                        else {
                            if ((response.scheduledStartDate != nil && response.scheduledStartDate != "") && (response.scheduledEndDate != nil && response.scheduledEndDate != "")){
                                self.arrivePreviewHidden(value: false)
                                self.arrivePreviewLabel.text = "entre " + response.scheduledStartDate! + " e " + response.scheduledEndDate!
                            }
                            else if ((response.scheduledStartDate != nil && response.scheduledStartDate != "") && (response.scheduledEndDate == nil || response.scheduledEndDate == "")){
                                self.arrivePreviewHidden(value: false)
                                self.arrivePreviewLabel.text = response.scheduledStartDate
                            }
                        }
                    self.removeLoading{}
                    },
                   error: {result in
                        //TODO Alert Feedback to user
                        print ("error")
                        self.showError(description: Configuration.errorDefault)
        })
        
    }
    
    func resolveDispatchStatus(status: String, scheduled: Bool) -> String{
        for line in Configuration.dispatchStatusValues{
            if (line[0] == status && !scheduled){
                return line[1]
            }
            else if (line[0] == status && line[2] == "1" && scheduled){
                return line[1]
            }
        }
        
        return resolveDispatchStatus(status:status, scheduled:false)
    }

    func arrivePreviewHidden(value: Bool){
        self.arrivePreviewTitle.isHidden = value
        self.arrivePreviewLabel.isHidden = value
    }
    
    func plateHidden(value: Bool){
        self.plateLabelTitle.isHidden = value
        self.plateLabel.isHidden = value
    }
}

