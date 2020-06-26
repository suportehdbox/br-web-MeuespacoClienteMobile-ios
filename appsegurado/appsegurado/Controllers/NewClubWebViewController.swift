//
//  NewClubWebViewController.swift
//  appsegurado
//
//  Created by Luiz Zenha on 23/06/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation
import WebKit

class NewClubWebViewController: BaseViewController, WKNavigationDelegate, ClubModelDelegate  {
    var webView: WKWebView!
    
    func clubeError(_ message: String!) {
//        alertCo
    }
    
    func clubeSession(_ sessionID: String!, url: String!) {
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postString = "token="+sessionID
        urlRequest.httpBody = postString.data(using: .utf8)
        webView.load(urlRequest)
        
    }
    
    func updateClubImage(_ image: UIImage!) {
//        /nothing
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ClubeVantagens", comment: "")
        
        let baseModel = ClubModel()!
        baseModel.delegate = self
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self;
        self.view = webView;
        
        
        webView.allowsBackForwardNavigationGestures = false;
               
        baseModel.getClientSession()
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
