//
//  HomeAssistWebViewController.swift
//  appsegurado
//
//  Created by Luiz Zenha on 07/05/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation
import WebKit

class HomeAssistWebViewController: BaseViewController, WKNavigationDelegate  {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("AssistenciaResidenciaTitulo", comment: "");
        
        let baseModel = BaseModel()!
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self;
        self.view = webView;
        
        let delegate:AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        let token: String! = delegate.getLoggeduser()?.access_token
        
        webView.load(URLRequest(url: URL(string: (baseModel.getHomeAssistUrl()+"?token="+token+"&cacheControle=1234") )!))
        
        webView.allowsBackForwardNavigationGestures = false;
        
        
        if(self.navigationController?.viewControllers.first == self){
            super.addLeftMenu()     
        }
        	
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if(["tel", "sms"].contains(url.scheme)){
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

