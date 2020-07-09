//
//  CustomPopUp.swift
//  appsegurado
//
//  Created by Luiz Zenha on 09/07/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation

class CustomPopUpViewController: UIViewController {
    let bgPopUp: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = BaseView.getColor("CinzaTexto")
        lbl.font = BaseView.getDefatulFont(XLarge, bold: true)
        lbl.numberOfLines = 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let txtMessage: UITextView = {
       let txt = UITextView()
        txt.textColor = BaseView.getColor("CinzaTexto")
        txt.font = BaseView.getDefatulFont(Medium, bold: false)
        txt.isEditable = false
        txt.isScrollEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()

    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = BaseView.getColor("Amarelo")
        button.setTitleColor(BaseView.getColor("AzulEscuro"), for: .normal)
        button.titleLabel?.font = BaseView.getDefatulFont(Medium, bold: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        return button
    }()
    
    @objc init(title: String, text:String, btTitle: String) {
        super.init(nibName: nil, bundle: nil)
        lblTitle.text = title
        txtMessage.text = text
        button.setTitle(btTitle, for: .normal)
        self.modalPresentationStyle = .overCurrentContext
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        self.view.isOpaque = true
        
        self.view.addSubview(bgPopUp)
        
        bgPopUp.setLeadingConstraint(withAnchor: self.view.leadingAnchor, constant: 15)
        bgPopUp.setTrailingConstraint(withAnchor: self.view.trailingAnchor, constant: -15)
        bgPopUp.setCenterYConstraint(withAnchor: self.view.centerYAnchor, constant: 0)
        bgPopUp.setMinimumHeight(constant: 300)
        
        
        bgPopUp.addSubview(lblTitle)
        lblTitle.setLeadingConstraint(withAnchor: bgPopUp.leadingAnchor, constant: 27)
        lblTitle.setTrailingConstraint(withAnchor: bgPopUp.trailingAnchor, constant: -27)
        lblTitle.setTopConstraint(withAnchor: bgPopUp.topAnchor, constant: 35)
        lblTitle.setHeightConstraint(constant: 40)
        
        bgPopUp.addSubview(txtMessage)
        txtMessage.setLeadingConstraint(withAnchor: bgPopUp.leadingAnchor, constant: 27)
        txtMessage.setTrailingConstraint(withAnchor: bgPopUp.trailingAnchor, constant: -27)
        txtMessage.setTopConstraint(withAnchor: lblTitle.bottomAnchor, constant: 35)
        txtMessage.setMinimumHeight(constant: 100)
        
        txtMessage.sizeToFit()
        
        bgPopUp.addSubview(button)
        button.setLeadingConstraint(withAnchor: bgPopUp.leadingAnchor, constant: 27)
        button.setTrailingConstraint(withAnchor: bgPopUp.trailingAnchor, constant: -27)
        button.setTopConstraint(withAnchor: txtMessage.bottomAnchor, constant: 20)
        button.setHeightConstraint(constant: 55)
        
        
        bgPopUp.setBottomConstraint(withAnchor: button.bottomAnchor, constant: 20)
        
    }
    
    
    @objc func addButtonAction(target: Any? , action: Selector, pfor:UIControl.Event){
        button.addTarget(target, action: action, for: pfor)
    }
}


