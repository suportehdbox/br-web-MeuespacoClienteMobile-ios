//
//  AutoClaimWebView.swift
//  appsegurado
//
//  Created by Luiz Othavio H Zenha on 06/10/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation
import WebKit


class AutoClaimWebViewController: BaseViewController, WKNavigationDelegate  {
    var webView: WKWebView!
    var beans : InsuranceBeans!
    var cpfLogged : String = ""
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Sinistro", comment: "");
        
        let baseModel = BaseModel()!
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self;
        self.view = webView;
        
        let delegate:AppDelegate =  UIApplication.shared.delegate as! AppDelegate
//        let token: String! = delegate.getLoggeduser()?.access_token
      
        let item: ItemInsurance =  beans.itens[0] as! ItemInsurance
        
        let cpf = self.cpfLogged != "" ? self.cpfLogged : delegate.getCPF()
        let uri: String = "\( baseModel.getAutoClaimUrl()!)?plate=\(beans.licensePlate ?? "")&document=\(cpf!)&issuingAgency=\(beans.issuingAgency)&itemCode=\(item.code)&brandMarketing=\( baseModel.getBrandMarketing()!)"
        webView.load(URLRequest(url: URL(string: uri)!))
        
        webView.allowsBackForwardNavigationGestures = false;
        webView.isMultipleTouchEnabled = false
        
        if(self.navigationController?.viewControllers.first == self){
            super.addLeftMenu()
        }
            
    }
    
   @objc func setInsuranceBeans(_ b: InsuranceBeans) -> Void{
        self.beans = b
    }
    
    @objc func setUserNotLoggendInCPF ( _ cpf : String) -> Void {
        self.cpfLogged = cpf
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if(["tel", "sms"].contains(url.scheme) || url.absoluteString.contains("#external")){
            UIApplication.shared.openURL(url)
            decisionHandler(.cancel);
        }else if(url.absoluteString.contains("#home")){
            self.navigationController?.popToRootViewController(animated: false)
            decisionHandler(.cancel);
        }else  if(["share"].contains(url.scheme)){
            
            let title = url.pathComponents[1]
            let text = url.pathComponents[2]
            let ac = UIActivityViewController(activityItems: [title, text], applicationActivities: nil)
            present(ac, animated: true, completion: nil)
            
            decisionHandler(.cancel);
        }else{
            decisionHandler(.allow);
        }
        
    }
    
}

