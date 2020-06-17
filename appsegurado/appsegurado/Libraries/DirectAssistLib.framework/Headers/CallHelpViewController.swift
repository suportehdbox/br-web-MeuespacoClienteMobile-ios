//
//  CallHelpViewController.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 25/06/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import UIKit

public class CallHelpViewController: DirectAssistViewController {
    
    static let identifier = "CallHelpViewController"
    
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var phoneInput: UITextField!
    
    var model : String = ""
    var policyID: String = ""
    var location: CallingLocation?
    var locationTap: UITapGestureRecognizer?
    var caseNumber: String?
    var references: String?
    var phoneCode: String?
    var phoneNumber: String?
    var startDate: String?
    var endDate: String?
    var lists: [OptionsListView] = []
    var locationView: OptionLocationView?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading {
            let navBar = self.navigationController!.navigationBar
            navBar.barTintColor = Configuration.blueColor1
            navBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Arial-BoldMT", size: 15)!,
                                          NSAttributedStringKey.foregroundColor: UIColor.white]
            self.title = "Chamar Guincho/Auxílio mecânico"
            
            self.hideKeyboardWhenTappedAround()
        
            self.phoneInput.isUserInteractionEnabled = false
            self.phoneInput.keyboardType = UIKeyboardType.numberPad
        
            self.callButton.isEnabled = false
        
            if var phone = DirectAssist.phone{
                self.phoneInput.text = phone.applyMask(mask: "(##) #####-####")
            
            }
            
            self.scheduleDate()
        
            print("viewDidLoad")
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.lists.isEmpty {
            let list = OptionsListView()
            list.delegate = self
            self.contentStack.addArrangedSubview(list)
            list.addOption(option: "Acidente", state: false)
            list.addOption(option: "Pane", state: false)
            
            self.lists.append(list)
            
            if (DirectAssist.chassi! == ""){
                self.getPolicy()
            }
            else{
                self.getPolicyChassis()
            }
        }
        
    }
    
    func getPolicyChassis(){
        let api = GetPolicyChassisServer()
        let requestObject = GetPolicyChassisRequest()
        requestObject.chassi = DirectAssist.chassi!
        requestObject.document = DirectAssist.cpf!
        api.doCall(requestObject: requestObject, success: { response in
            if let model = response.policy?.vehicle?.model {
                self.model = model
            }
            if let policyID = response.policy?.policyId {
                self.policyID = policyID
            }
            if (self.policyID == ""){
                self.showError(description: "Contrato não localizado.")
                print ("Contrato não localizado.")
            }
            else {
                self.salvePolicy()
            }
            
        }, error: { result in
            //TODO Alert Feedback to user
            self.showError(description: Configuration.errorDefault)
            print("error")
        })
        
    }
    
    func getPolicy(){
        let api = GetPolicyServer()
        let requestObject = GetPolicyRequest()
        requestObject.plate = DirectAssist.plate!
        requestObject.document = DirectAssist.cpf!
        api.doCall(requestObject: requestObject, success: { response in
            if let model = response.policy?.vehicle?.model {
                self.model = model
            }
            if let policyID = response.policy?.policyId {
                self.policyID = policyID
            }
            if (self.policyID == ""){
                self.showError(description: "Contrato não localizado.")
                print ("Contrato não localizado.")
            }
            else {
                self.salvePolicy()
            }
            
        }, error: { result in
            //TODO Alert Feedback to user
            self.showError(description: Configuration.errorDefault)
            print("error")
        })
        
    }
    
    func salvePolicy(){
        let api = SavePolicyServer()
        let requestObject = SavePolicyRequest()
        requestObject.policyID = self.policyID
        api.doCall(requestObject: requestObject, success: { response in
            print("success salvePolicy")
            self.phoneInput.isUserInteractionEnabled = true
            if (self.phoneInput.text?.removeMask(mask: "/- ()").characters.count == 11){
                self.lists[0].changeStateCheckBox(value: true)
            }
            self.removeLoading{}
        }, error: { result in
            //TODO Alert Feedback to user
            self.showError(description: Configuration.errorDefault)
            print("error")
        })
        
    }
    
    func scheduleDate(){
        
        let now = Date()
        let tempCalendar = Calendar.current
        let startDate = tempCalendar.date(byAdding: .hour, value: 1, to: now)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH"
        
        self.startDate = formatter.string(from: startDate!) + ":00"
        self.startDate = self.startDate!.replacingOccurrences(of: " ", with: "T")
        
        let endDate = tempCalendar.date(byAdding: .hour, value: 2, to: now)
        
        self.endDate = formatter.string(from: endDate!) + ":00"
        self.endDate = self.endDate!.replacingOccurrences(of: " ", with: "T")
    }
    
    func removeList(title: String){
        if (title == "Localização do Veículo"){
            return
        }
        else {
            if (self.lists.last?.title == title){
                if (self.locationView != nil){
                    self.locationView!.removeFromSuperview()
                    self.locationView = nil
                }
                return
            }
            else{
                if (self.locationView != nil){
                    self.locationView!.removeFromSuperview()
                    self.locationView = nil
                }
                self.lists.last?.removeFromSuperview()
                self.lists.removeLast()
                removeList(title: title)
            }
        }
        
        self.callButton.isEnabled = false
        
    }
    
    func inList(title: String) -> Bool{
        for element in self.lists{
            if (element.title == title){
                return true
            }
        }
        
        return false
    }
    
    func findList(title: String) -> OptionsListView {
        for element in self.lists{
            if (element.title == title){
                return element
            }
        }
        return OptionsListView()
    }
    
    @objc func openSelectLocation() {
        print("openSelectLocation")
        let locationViewController = DirectAssistRouter.locationScreen()
        locationViewController.delegate = self
        self.navigationController?.pushViewController(locationViewController, animated: true)
    }
    
    @IBAction func actionCallButton(_ sender: Any) {
        print("Loading")
        self.showLoading {
            self.phoneCode = DirectAssist.phone![0...1]
            self.phoneNumber = DirectAssist.phone![2...DirectAssist.phone!.characters.count-1]
            // criando caso
            let api = CreateCaseServer()
            let requestObject = CreateCaseRequest()
            requestObject.contractNumber = self.policyID
            requestObject.phoneAreaCode = self.phoneCode!
            requestObject.phoneNumber = self.phoneNumber!
            requestObject.fileCause = self.getCause()
            requestObject.serviceCode = self.getService()
            requestObject.problemCode = self.getProblem()
            requestObject.fileCity = self.location!.city!.uppercased()
            requestObject.fileState = self.location!.state!.uppercased()
            requestObject.address = self.location!.address!
            requestObject.addressNumber = self.location!.addressNumber!
            requestObject.latitude = String(format:"%.6f", self.location!.latitude!)
            requestObject.longitude = String(format:"%.6f", self.location!.longitude!)
            
            api.doCall(requestObject: requestObject, success: { response in
                // consultando cobertura
                print(response.caseNumber)
                
                self.caseNumber = response.caseNumber
                self.references = self.locationView!.referenceView?.textField.text
                
                let ccApi = CheckCoveragesServer()
                let ccRequestObject = CheckCoveragesRequest()
                ccRequestObject.fileNumber = self.caseNumber!
                ccRequestObject.contractNumber = self.policyID
                ccRequestObject.phoneAreaCode = self.phoneCode!
                ccRequestObject.phoneNumber = self.phoneNumber!
                ccRequestObject.fileCause = self.getCause()
                ccRequestObject.serviceCode = self.getService()
                ccRequestObject.problemCode = self.getProblem()
                ccRequestObject.fileCity = self.location!.city!.uppercased()
                ccRequestObject.fileState = self.location!.state!.uppercased()
                ccRequestObject.address = self.location!.address!
                ccRequestObject.addressNumber = self.location!.addressNumber!
                ccRequestObject.latitude = String(format:"%.6f", self.location!.latitude!)
                ccRequestObject.longitude = String(format:"%.6f", self.location!.longitude!)
                ccRequestObject.reference = self.references!
                ccApi.doCall(requestObject: ccRequestObject, success: { response in
                    print("success checkCovarages")
                    // localizando um prestador mais próximo
                    let csdApi = CreateServiceDispatchServer()
                    let csdRequestObject = CreateServiceDispatchRequest()
                    csdRequestObject.fileNumber = self.caseNumber!
                    csdRequestObject.contractNumber = self.policyID
                    csdRequestObject.phoneAreaCode = self.phoneCode!
                    csdRequestObject.phoneNumber = self.phoneNumber!
                    csdRequestObject.fileCause = self.getCause()
                    csdRequestObject.serviceCode = self.getService()
                    csdRequestObject.problemCode = self.getProblem()
                    csdRequestObject.fileCity = self.location!.city!.uppercased()
                    csdRequestObject.fileState = self.location!.getSate(state: self.location!.state!).uppercased()
                    csdRequestObject.address = self.location!.address!
                    csdRequestObject.addressNumber = self.location!.addressNumber!
                    csdRequestObject.latitude = String(format:"%.6f", self.location!.latitude!)
                    csdRequestObject.longitude = String(format:"%.6f", self.location!.longitude!)
                    csdRequestObject.reference = self.references!
                    csdRequestObject.district = self.location!.subLocality!
                    //csdRequestObject.scheduleStartDate = self.startDate!
                    //csdRequestObject.scheduleEndDate = self.endDate!
                    
                    csdApi.doCall(requestObject: csdRequestObject, success: { response in
                        // sucess
                        self.showSuccess(title: "Assistência criada com sucesso", description: String(self.caseNumber!) + " é o número da sua assistência. Você pode acompanhar seu atendimento escolhendo a opção Minhas Assistências.")
                    }, error: { result in
                        print("error localizando prestador")
                        self.showError(description: Configuration.errorDefault)
                    })
                    
                }, error: { result in
                    print("error consultando cobertura")
                    self.showError(description: Configuration.errorDefault)
                })
                
            }, error: { result in
                print("error criando caso")
                self.showError(description: Configuration.errorDefault)
            })
        }
        
    }
    
    func getCause() -> String {
        let cause = findList(title: "O que aconteceu?")
        let selected = cause.whoIsChecked()
        
        for element in Configuration.causes {
            if (selected == element[1]){
                return element[0]
            }
        }
        
        return ""
    }
    
    func getProblem() -> String {
        let problem = findList(title: "Problema")
        let selected = problem.whoIsChecked()
        
        for element in Configuration.problems {
            if (selected == element[1]){
                return element[0]
            }
        }
        
        return "0"
    }
    
    func getService() -> String {
        let service = findList(title: "Serviço")
        let selected = service.whoIsChecked()
        
        for element in Configuration.services {
            if (selected == element[1]){
                return element[0]
            }
        }
        
        return ""
    }
    
}

extension CallHelpViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var flag : Bool = false
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        let validInput = string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        if !validInput {
            return false
        }
        guard let text = textField.text, let resultRange = text.range(from: range) else {
            return true
        }
        var cleanText = text.replacingCharacters(in: resultRange, with: string)
        cleanText = cleanText.removeMask(mask: "/- ()")
        if (cleanText.characters.count == 11){
            flag = true
            DirectAssist.phone = cleanText
        }
        else{
            self.removeList(title: "O que aconteceu?")
            self.lists[0].options.last?.unselect()
            self.lists[0].options.first?.unselect()
            self.lists[0].changeStateCheckBox(value: false)
        }
        
        if (cleanText.characters.count != 0) {
            cleanText = cleanText.applyMask(mask: "(##) #####-####")
        }
        else {
            cleanText = ""
        }
        
        textField.text = cleanText
        if (flag){
            self.lists[0].changeStateCheckBox(value: true)
            textField.resignFirstResponder()
        }
        
        return false
    }
    
}

extension CallHelpViewController: OptionsListDelegate {
    
    func didSelect(option: String, list: OptionsListView) {
        if (list.title == "O que aconteceu?") {
            handleSelectionWhatHappen(option: option, list: list)
        } else if (list.title == "Problema"){
            handleSelectionProblem(option: option, list: list)
        } else if (list.title == "Serviço"){
            addComponentForLocation()
        }
    }
    
    func handleSelectionWhatHappen(option: String, list: OptionsListView) {
        if (option == "Pane"){
            if (!self.inList(title: "Problema")){
                removeList(title: list.title)
                let title = "Problema"
                let options = ["Bateria",
                               //"Motor",
                               "Motor não pega",
                               "Pane elétrica",
                               //"Outros"
                            ]
                let _ = self.addComponent(title: title, options: options)
            }
        } else if (option == "Acidente"){
            removeList(title: list.title)
            let title = "Serviço"
            let options = ["Reboque"]
            let list = self.addComponent(title: title, options: options)
            list.options.last?.actionSelect(nil)
        }
    }
    
    func handleSelectionProblem(option: String, list: OptionsListView) {
        if (self.inList(title: "Serviço")){
            let element = findList(title: "Serviço")
            element.options.first?.unselect()
            element.options.last?.unselect()
        } else {
            let title = "Serviço"
            let options = ["Reboque",
                           "Conserto no Local"]
            let _ = self.addComponent(title: title, options: options)
        }
        if (option != "Outros"){
            findList(title: "Serviço").options.last?.select()
            addComponentForLocation()
        } else {
            removeList(title: "Serviço")
        }
    }
    
    func addComponentForLocation() {
        if (self.locationView == nil){
            let list = OptionLocationView()
            list.delegate = self
            contentStack.addArrangedSubview(list)
            if let locationTap = locationTap {
                locationTap.view?.removeGestureRecognizer(locationTap)
            }
            locationTap = UITapGestureRecognizer(target: self, action: #selector(openSelectLocation))
            list.addGestureRecognizer(locationTap!)
            self.locationView = list
            
        }
    }
    
    func addComponent(title: String, options: [String]) -> OptionsListView {
        let list = OptionsListView()
        list.delegate = self
        contentStack.addArrangedSubview(list)
        for option in options {
            list.addOption(option: option, state: true)
        }
        list.title = title
        self.lists.append(list)
        return list
    }
    
    
}

extension CallHelpViewController: LocationMapDelegate{
    
    func hasNewLocation(location: CallingLocation){
        self.locationView!.addInfoView(info: location)
        self.location = location
        callButton.isEnabled = true
    }
    
}

extension CallHelpViewController: OptionLocationViewDelegate {
    
    func getLocation(location: CallingLocation) {
        self.location = location
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    
    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[startIndex...endIndex])
        }
    }
}

