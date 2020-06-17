//
//  MyCasesViewController.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 26/07/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import UIKit

public class MyCasesViewController: DirectAssistViewController {

    static let identifier = "MyCasesViewController"
    
    @IBOutlet weak var tableView: UITableView!

    var cases: [AutomotiveCase] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading{
            let navBar = self.navigationController!.navigationBar
            navBar.barTintColor = Configuration.blueColor1
            navBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Arial-BoldMT", size: 15)!,
                                      NSAttributedStringKey.foregroundColor: UIColor.white]
        
            self.title = "Acompanhar Assistência"
        
            self.getListCases()
        }
    }
    
    func getListCases(){
        let api = ListCasesServer()
        let requestObject = ListCasesRequest()
        api.doCall(requestObject: requestObject,
                   success: { response in
                        self.cases = response.cases
                        self.tableView.reloadData()
                        self.removeLoading{}
                    }, error: {result in
                        //TODO Alert Feedback to user
                        if (result.resultCode! == "100"){
                            self.showError(description: "Nenhuma assistência localizada.")
                        }
                        else {
                            print("error")
                            self.showError(description: Configuration.errorDefault)
                        }
                    })
        
    }


}

extension MyCasesViewController: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CaseTableViewCell.identifier, for: indexPath) as! CaseTableViewCell
        let automotiveCase = cases[indexPath.row]
        cell.automotiveCase = automotiveCase
        
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let automotiveCase = cases[indexPath.row]
        let caseScreen = DirectAssistRouter.caseScreen()
        caseScreen.automotiveCase = automotiveCase
         self.navigationController?.pushViewController(caseScreen, animated: true)

    }

}
