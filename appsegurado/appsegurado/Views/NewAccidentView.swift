//
//  NewAccidentView.swift
//  appsegurado
//
//  Created by Luiz Zenha on 05/05/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol NewAccidentViewDelegate {
    func openClaim()
    func openGlassAssist()
    func openHomeAssist()
    func openAutoAssist()
    func openContact()
    func openStatusClaim()
    
}

class NewAccidentView: UIView{
    
    var lblTitle: UILabel!
    var lblSubTitle: UILabel!
    var btSinister: UIButton!
    var bt24Assist: UIButton!
    var btGlassAssist: UIButton!
    var btHomeAsssist: UIButton?
    var btStatusClaim: CustomButton!
    var btFooterHelp: UIButton!
    
    @objc public var delegate: NewAccidentViewDelegate?
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    @objc public init(frame: CGRect , allowPHS : Bool, loggedInUser : Bool){
        super.init(frame: frame)
        
        var shouldAllowPHS = allowPHS
        if (Config.isAliroProject()) {
            shouldAllowPHS = false
        }
        createTitles(allowPHS: shouldAllowPHS)
        createButtons(allowPHS: shouldAllowPHS, loggedInUser: loggedInUser)
        
        
        btFooterHelp = UIButton()
        btFooterHelp.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btFooterHelp)
        
        btFooterHelp.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        btFooterHelp.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        btFooterHelp.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        if #available(iOS 11.0, *) {
            btFooterHelp.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        } else {
            btFooterHelp.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        }
        
        
        let titleButton = NSMutableAttributedString()
        titleButton.append(NSAttributedString(string: NSLocalizedString("EstouComDuvidas", comment: ""), attributes: [NSAttributedString.Key.font : BaseView.getDefatulFont(Micro, bold: false)!, NSAttributedString.Key.foregroundColor : BaseView.getColor("CinzaEscuro")! ]))
        titleButton.append(NSAttributedString(string:" ", attributes: [NSAttributedString.Key.font : BaseView.getDefatulFont(Micro, bold: false)!, NSAttributedString.Key.foregroundColor : BaseView.getColor("CinzaEscuro")! ]))
        
        titleButton.append(NSAttributedString( string: NSLocalizedString("FaleComLiberty", comment: ""), attributes: [
            NSAttributedString.Key.underlineColor : BaseView.getColor("AzulEscuro")!,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor : BaseView.getColor("AzulEscuro")!,
            NSAttributedString.Key.font : BaseView.getDefatulFont(Micro, bold: false)!
            
            ]
        ))
        btFooterHelp.setAttributedTitle(titleButton, for: .normal)
        btFooterHelp.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0  )
        btFooterHelp.addTarget(self, action: #selector(btContactClick(_:)), for: .touchUpInside)
    }
    
    func createTitles (allowPHS : Bool){
        self.backgroundColor = .white
        lblTitle = UILabel()
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblTitle)
        
        lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        
        if(allowPHS){
            lblTitle.text = NSLocalizedString("TipoAtendimentoHome", comment: "")
        }else{
            lblTitle.text = NSLocalizedString("TipoAtendimento", comment: "")
        }
        
        
        lblTitle.font = BaseView.getDefatulFont(Medium, bold: true)
        lblTitle.textColor = BaseView.getColor("AzulEscuro")
        lblTitle.textAlignment = .left
        lblTitle.numberOfLines = 0
        lblTitle.sizeToFit()
        
        lblSubTitle  = UILabel()
        lblSubTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblSubTitle)
        
        lblSubTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lblSubTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        lblSubTitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20).isActive = true
        
        lblSubTitle.text = NSLocalizedString("EscolhaAtendimento", comment: "")
        lblSubTitle.font = BaseView.getDefatulFont(Small, bold: false)
        lblSubTitle.textColor = BaseView.getColor("CinzaEscuro")
        lblSubTitle.textAlignment = .left
        lblSubTitle.numberOfLines = 1
        lblSubTitle.sizeToFit()
    }
    
    func createButtons(allowPHS : Bool, loggedInUser :Bool){
        
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.35).isActive = true
        stackView.topAnchor.constraint(equalTo: lblSubTitle.bottomAnchor, constant: allowPHS ? 20 : 80).isActive = true
        
        var stackViewSec = UIStackView()
        
        
        if(allowPHS){
            stackViewSec.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(stackViewSec)
            stackViewSec.axis = .horizontal
            stackViewSec.alignment = .center
            stackViewSec.distribution = .fillProportionally
            
            stackViewSec.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            stackViewSec.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            stackViewSec.heightAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.35).isActive = true
            stackViewSec.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40).isActive = true
        }else{
            stackViewSec = stackView
        }
        
        btSinister = UIButton()
        stackView.addArrangedSubview(btSinister)
        btSinister.setImage(UIImage(named: "btSinister.png"), for: .normal)
        btSinister.imageView?.contentMode = .scaleAspectFit
        btSinister.addTarget(self, action: #selector(btSinisterClick(_:)), for: .touchUpInside)
        
        bt24Assist = UIButton()
        stackView.addArrangedSubview(bt24Assist)
        bt24Assist.setImage(UIImage(named: "btAssist24.png"), for: .normal)
        bt24Assist.imageView?.contentMode = .scaleAspectFit
        bt24Assist.addTarget(self, action: #selector(btAutoAssistClick(_:)), for: .touchUpInside)
        
        
        btGlassAssist = UIButton()
        stackViewSec.addArrangedSubview(btGlassAssist)
        btGlassAssist.setImage(UIImage(named: "icon_oval_glass.png"), for: .normal)
        btGlassAssist.imageView?.contentMode = .scaleAspectFit
        btGlassAssist.addTarget(self, action: #selector(btGlassAssistClick(_:)), for: .touchUpInside)
        
        if(allowPHS){
            btHomeAsssist = UIButton()
            stackViewSec.addArrangedSubview(btHomeAsssist!)
            btHomeAsssist!.setImage(UIImage(named: "icon_oval_home.png"), for: .normal)
            btHomeAsssist!.imageView?.contentMode = .scaleAspectFit
            btHomeAsssist!.addTarget(self, action: #selector(btHomeAssistClick(_:)), for: .touchUpInside)
        }
        
        let baseView = UIView()
        baseView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseView)
        
        baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        baseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        baseView.topAnchor.constraint(equalTo: stackViewSec.bottomAnchor, constant: 10).isActive = true
        baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        if(loggedInUser){
            btStatusClaim = CustomButton()
            btStatusClaim.translatesAutoresizingMaskIntoConstraints = false
            baseView.addSubview(btStatusClaim)
            
            btStatusClaim.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20).isActive = true
            btStatusClaim.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20).isActive = true
            btStatusClaim.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
            btStatusClaim.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            
            btStatusClaim.setTitle(NSLocalizedString("MyClaims", comment: "").uppercased(), for: .normal)
            btStatusClaim.borderColor = BaseView.getColor("Amarelo")
            btStatusClaim.customizeBorderColor(BaseView.getColor("Amarelo"), borderWidth: 1, borderRadius: 7)
            btStatusClaim.backgroundColor = BaseView.getColor("Amarelo")
            btStatusClaim.setTitleColor(BaseView.getColor("CorBotoes"), for: .normal)
            btStatusClaim.titleLabel?.font = BaseView.getDefatulFont(Small, bold: false)
            btStatusClaim.addTarget(self, action: #selector(btStatusClaimClick(_:)), for: .touchUpInside)
            
            
            if (Config.isAliroProject()) {
                btStatusClaim.backgroundColor = BaseView.getColor("Branco")
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    
    @IBAction func btStatusClaimClick(_ sender:UIButton){
        delegate?.openStatusClaim()
    }
    
    @IBAction func btSinisterClick(_ sender: UIButton) {
        delegate?.openClaim()
    }
    
    @IBAction func btGlassAssistClick(_ sender: UIButton) {
        delegate?.openGlassAssist()
    }
    @IBAction func btAutoAssistClick(_ sender: UIButton) {
        delegate?.openAutoAssist()
    }
    
    @IBAction func btHomeAssistClick(_ sender: UIButton) {
        delegate?.openHomeAssist()
    }
    
    @IBAction func btContactClick(_ sender: UIButton) {
        delegate?.openContact()
    }
    
    
}
