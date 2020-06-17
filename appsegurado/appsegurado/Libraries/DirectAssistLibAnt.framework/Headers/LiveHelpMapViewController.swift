//
//  LiveHelpMapViewController.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 26/07/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

public class LiveHelpMapViewController: DirectAssistViewController {

    static let identifier = "LiveHelpMapViewController"

    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    
    var caseNumber: String?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading{
            let navBar = self.navigationController!.navigationBar
            navBar.barTintColor = Configuration.blueColor1
            navBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Arial-BoldMT", size: 15)!,
                                          NSAttributedStringKey.foregroundColor: UIColor.white]
            self.title = "Localização do Prestador"
        
            GMSServices.provideAPIKey("AIzaSyAxZslAs9AUz58aizAn6EXjBku4u3oNQY4")
            let camera = GMSCameraPosition.camera(withLatitude: -23.616696, longitude: -46.612050, zoom: 17.0)
            self.mapView = GMSMapView.map(withFrame: self.mapContainer.bounds, camera: camera)
            self.mapView.delegate = self
            self.mapContainer.addSubview(self.mapView)
            
            self.setMarker(latitude: -23.616696, longitude: -46.612050)
            
            self.getDispatchStatus()
        }
    }
    
    func setMarker(latitude: Double, longitude: Double){
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "icPin", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
        marker.map = self.mapView
    }
    
    func getDispatchStatus(){
        let api = GetDispatchStatusServer()
        let requestObject = GetDispatchStatusRequest()
        if let cn = self.caseNumber {
            requestObject.caseNumber = cn
        }
        api.doCall(requestObject: requestObject,
                   success: {response in
                        if ((response.providerLatitude != nil && response.providerLatitude != "") && (response.providerLongitude != nil && response.providerLongitude != "")){
                            self.mapView.clear()
                            
                            let camera = GMSCameraPosition.camera(withLatitude: Double(response.providerLatitude!)!, longitude: Double(response.providerLongitude!)!, zoom: 17.0)
                            let update = GMSCameraUpdate.setCamera(camera)
                            self.mapView.moveCamera(update)
                            
                            self.setMarker(latitude: Double(response.providerLatitude!)!, longitude: Double(response.providerLongitude!)!)
                            self.removeLoading{}
                        }
                        else {
                            print ("error ao localizar prestador")
                            self.showError(description: Configuration.errorDefault)
                        }
                   
                },
                   error: {result in
                        //TODO Alert Feedback to user
                        self.showError(description: Configuration.errorDefault)
                        print ("error")
                    
                })
        
    }

}

extension LiveHelpMapViewController: GMSMapViewDelegate {
    
}
