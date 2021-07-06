//
//  CustomPopUp.swift
//  appsegurado
//
//  Created by Luiz Zenha on 09/07/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation

class PopUpForceResetPassawordViewController: UIViewController {
    let bgPopUp: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = BaseView.getColor("AzulClaroTexto")
        lbl.font = BaseView.getDefatulFont(Large, bold: true)
        lbl.numberOfLines = 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let lblTitleIcon = UIImageView()
    
    let txtMessage: UITextView = {
       let txt = UITextView()
        txt.textColor = BaseView.getColor("Branco")
        txt.font = BaseView.getDefatulFont(Medium, bold: false)
        txt.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        txt.isEditable = false
        txt.isScrollEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()

    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = BaseView.getColor("AzulClaroTexto")
        button.setTitleColor(BaseView.getColor("AzulEscuro"), for: .normal)
        button.titleLabel?.font = BaseView.getDefatulFont(Medium, bold: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 26
        return button
    }()
    
    @objc init(title: String, text:String, btTitle: String) {
        super.init(nibName: nil, bundle: nil)
        lblTitle.text = title
        txtMessage.text = text
        button.setTitle(btTitle, for: .normal)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.90)
        self.view.isOpaque = true
        
        self.view.addSubview(bgPopUp)
        
        bgPopUp.setLeadingConstraint(withAnchor: self.view.leadingAnchor, constant: 0)
        bgPopUp.setTrailingConstraint(withAnchor: self.view.trailingAnchor, constant: 0)
        bgPopUp.setTopConstraint(withAnchor: self.view.topAnchor, constant: 50)
        bgPopUp.setBottomConstraint(withAnchor: self.view.bottomAnchor, constant: -50)
    
        lblTitleIcon.translatesAutoresizingMaskIntoConstraints = false
        bgPopUp.addSubview(lblTitleIcon)
        
        lblTitleIcon.setCenterXConstraint(withAnchor: bgPopUp.centerXAnchor, constant: 0)
        lblTitleIcon.setTopConstraint(withAnchor: bgPopUp.topAnchor, constant: 40)
        lblTitleIcon.setHeightConstraint(constant: 70)
        
        lblTitleIcon.image = UIImage(named: "icon_exclamation")
        lblTitleIcon.contentMode = .scaleAspectFit
                
        bgPopUp.addSubview(lblTitle)
        lblTitle.setCenterXConstraint(withAnchor: bgPopUp.centerXAnchor, constant: 0)
        lblTitle.setTopConstraint(withAnchor: lblTitleIcon.bottomAnchor, constant: 25)
        lblTitle.setHeightConstraint(constant: 40)
        bgPopUp.addSubview(txtMessage)
        
        txtMessage.setLeadingConstraint(withAnchor: bgPopUp.leadingAnchor, constant: 25)
        txtMessage.setTrailingConstraint(withAnchor: bgPopUp.trailingAnchor, constant: -25)
        txtMessage.setTopConstraint(withAnchor: lblTitle.bottomAnchor, constant: 50)
        txtMessage.setMinimumHeight(constant: 100)
        
        txtMessage.sizeToFit()
        
        bgPopUp.addSubview(button)
        button.setLeadingConstraint(withAnchor: bgPopUp.leadingAnchor, constant: 27)
        button.setTrailingConstraint(withAnchor: bgPopUp.trailingAnchor, constant: -27)
        button.setTopConstraint(withAnchor: txtMessage.bottomAnchor, constant: 20)
        button.setHeightConstraint(constant: 55)
                
        bgPopUp.setBottomConstraint(withAnchor: button.bottomAnchor, constant: 20)
        
        if(Config.isAliroProject()){
            button.setTitleColor(BaseView.getColor("Branco"), for: .normal)
        }
    }
    
    
    @objc func addButtonAction(target: Any? , action: Selector, pfor:UIControl.Event){
        button.addTarget(target, action: action, for: pfor)
    }
}


