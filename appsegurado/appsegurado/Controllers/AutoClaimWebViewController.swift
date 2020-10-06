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
        
//        let delegate:AppDelegate =  UIApplication.shared.delegate as! AppDelegate
//        let token: String! = delegate.getLoggeduser()?.access_token
        
        webView.load(URLRequest(url: URL(string: (baseModel.getAutoClaimUrl()) )!))
        
        webView.allowsBackForwardNavigationGestures = false;
        webView.isMultipleTouchEnabled = false
        
        if(self.navigationController?.viewControllers.first == self){
            super.addLeftMenu()
        }
            
    }
    
   @objc func setInsuranceBeans(_ b: InsuranceBeans) -> Void{
        self.beans = b
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if(["tel", "sms", "#external"].contains(url.scheme)){
            UIApplication.shared.openURL(url)
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

