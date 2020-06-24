//
//  NewClubView.swift
//  appsegurado
//
//  Created by Luiz Zenha on 22/06/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation

class NewClubView: UIView {
    private var lblMessage: UILabel!
    private var lblItens: UILabel?
    private var lblAgreement: UIButton!
    private var imgView: UIImageView!
    private var btGotoLogin: CustomButton!
    private var btRegister: CustomButton!
    private var btOpenClub: CustomButton!
    private var switchAgreed: UISwitch!
    private var loggedIn:Bool = false
    var actionController:NewClubViewController?
    private var imgNames: [String] = ["image_baloes" , "imagem_familia", "Imagem_Loja", "imagem_celular"]
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    init(frame: CGRect, stepIndex: Int, loggedIn: Bool){
        super.init(frame: frame)
        self.loggedIn = loggedIn
        setupView(stepIndex: stepIndex)
        
    }
    
    required init?(coder: NSCoder) {
        //            super.init(coder:coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustLayout(){
        lblMessage.minimumScaleFactor = 0.1
        if #available(iOS 10.0, *) {
            lblMessage.adjustsFontForContentSizeCategory = true
        }
        lblMessage.adjustsFontSizeToFitWidth = true
        lblMessage.sizeToFit()
        lblMessage.layoutIfNeeded()
    }
    
    private func setupView(stepIndex: Int){
        
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imgView)
        
        lblMessage = UILabel()
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblMessage)
        
        
        imgView.setLeadingConstraint(withAnchor: self.leadingAnchor, constant: 40)
        imgView.setTrailingConstraint(withAnchor: self.trailingAnchor, constant: -40)
        
        
        imgView.image = UIImage(named: imgNames[stepIndex])
        imgView.contentMode = .scaleAspectFit
        
        //        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .center
        lblMessage.textColor = .black
        
        lblMessage.font = BaseView.getDefatulFont(Large, bold: false)
        lblMessage.numberOfLines = 0
        
        if(stepIndex != 3){
            lblMessage.setLeadingConstraint(withAnchor: self.leadingAnchor, constant: 35)
            lblMessage.setTrailingConstraint(withAnchor: self.trailingAnchor, constant: -35)
            lblMessage.text = NSLocalizedString("Step"+String(stepIndex), comment: "")
            
        }
        
        
        switch stepIndex {
        case 1:
            lblMessage.setTopConstraint(withAnchor: self.topAnchor, constant: 20)
            lblMessage.setHeightConstraint(constant: 220)
            imgView.setTopConstraint(withAnchor: self.centerYAnchor, constant: -40)
            
            if #available(iOS 11.0, *) {
                imgView.setBottomConstraint(withAnchor: self.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            }else{
                imgView.setBottomConstraint(withAnchor: self.bottomAnchor, constant: -40)
            }
            break;
        case 2:
            lblMessage.setTopConstraint(withAnchor: self.topAnchor, constant: 40)
            lblMessage.setHeightConstraint(constant: 80)
            imgView.setTopConstraint(withAnchor: lblMessage.bottomAnchor, constant: 20)
            imgView.setBottomConstraint(withAnchor: self.centerYAnchor, constant: 40)
            
            lblItens = UILabel()
            
            if let lbl = lblItens {
                self.addSubview(lbl)
                lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.setLeadingConstraint(withAnchor: self.leadingAnchor, constant: 35)
                lbl.setTrailingConstraint(withAnchor: self.trailingAnchor, constant: -35)
                lbl.setTopConstraint(withAnchor: imgView.bottomAnchor, constant: 20)
                lbl.setBottomConstraint(withAnchor: self.bottomAnchor, constant: 20)
                lbl.numberOfLines = 0
                let str: NSMutableAttributedString = NSMutableAttributedString(attributedString:  NSLocalizedString("Step2_Itens", comment: "").htmlAttributedString()!)
                
                lbl.attributedText = str
            }
            
           
            break;
        case 3:
            setupView3()
            break;
        default:
            imgView.setTopConstraint(withAnchor: self.topAnchor, constant: 30)
            imgView.setBottomConstraint(withAnchor: self.bottomAnchor, constant: -30)
            lblMessage.setCenterYConstraint(withAnchor: self.centerYAnchor, constant: 0)
            lblMessage.setHeightConstraint(constant: 200)
        }
        
        //Deve ser chamada ao final para aplicar corretamente
        lblMessage.addInterlineSpacing(spacingValue: 5)
    }
    
    private func setupView3(){
        let offApend:String = self.loggedIn ? "" : "off"
        
        imgView.setTopConstraint(withAnchor: self.topAnchor, constant: 40)
        imgView.setBottomConstraint(withAnchor: self.centerYAnchor, constant: -30)
        lblMessage.setCenterYConstraint(withAnchor: self.centerYAnchor, constant: 40)
        lblMessage.setLeadingConstraint(withAnchor: self.leadingAnchor, constant: 20)
        lblMessage.setTrailingConstraint(withAnchor: self.trailingAnchor, constant: -20)
        lblMessage.setHeightConstraint(constant: 100)
        lblMessage.numberOfLines = 3
        lblMessage.adjustsFontSizeToFitWidth = true
        lblMessage.minimumScaleFactor = 0.5
        
        let tempView = UIView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tempView)
        
        tempView.setTopConstraint(withAnchor: lblMessage.bottomAnchor, constant: 0)
        tempView.setLeadingConstraint(withAnchor: self.leadingAnchor, constant: 0)
        tempView.setTrailingConstraint(withAnchor: self.trailingAnchor, constant: 0)
        tempView.setBottomConstraint(withAnchor: self.bottomAnchor, constant: 0)
        
        if(self.loggedIn){
            switchAgreed = UISwitch()
            switchAgreed.translatesAutoresizingMaskIntoConstraints = false
            tempView.addSubview(switchAgreed)
            switchAgreed.setLeadingConstraint(withAnchor: tempView.leadingAnchor, constant: 20)
            switchAgreed.setBottomConstraint(withAnchor: tempView.centerYAnchor, constant: -10)
            switchAgreed.thumbTintColor = .white
            switchAgreed.tintColor = .white
            switchAgreed.backgroundColor = .white
            switchAgreed.layer.cornerRadius = switchAgreed.frame.height / 2
            switchAgreed.onTintColor = BaseView.getColor("CorBotoes")
            switchAgreed.addTarget(self, action: #selector(onChangeAgreement), for: .valueChanged)
            
            lblAgreement = UIButton(type: .custom)
            lblAgreement.translatesAutoresizingMaskIntoConstraints = false
            tempView.addSubview(lblAgreement)
            lblAgreement.setLeadingConstraint(withAnchor: tempView.leadingAnchor, constant: switchAgreed.frame.width + 30)
            lblAgreement.setTopConstraint(withAnchor: switchAgreed.topAnchor, constant: -10)
            lblAgreement.setBottomConstraint(withAnchor: switchAgreed.bottomAnchor, constant: 10)
            lblAgreement.setTrailingConstraint(withAnchor: tempView.trailingAnchor, constant: -20)
            lblAgreement.addTarget(actionController, action: #selector(NewClubViewController.gotoTerms), for: .touchUpInside)
            
            let txtAgreement = NSMutableAttributedString(string: NSLocalizedString("NovosTermos", comment: ""), attributes: [
                NSAttributedString.Key.font : BaseView.getDefatulFont(Small, bold: false)!,
                NSAttributedString.Key.foregroundColor : BaseView.getColor("CinzaEscuro")!
            ])
            txtAgreement.append(NSAttributedString(string: "\n"))
            txtAgreement.append(NSAttributedString(string: NSLocalizedString("NovosTermosLine", comment: ""), attributes: [
                NSAttributedString.Key.font : BaseView.getDefatulFont(Small, bold: false)!,
                NSAttributedString.Key.foregroundColor : BaseView.getColor("CinzaEscuro")!,
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.underlineColor : BaseView.getColor("CinzaEscuro")!
            ]))
            lblAgreement.setAttributedTitle(txtAgreement, for: .normal)
            lblAgreement.setTitleColor(BaseView.getColor("CinzaEscuro"), for: .normal)
            lblAgreement.titleLabel?.numberOfLines = 2
            lblAgreement.titleLabel?.adjustsFontSizeToFitWidth = true
            
            btOpenClub = CustomButton()
            btOpenClub.setNoRounedEffect()
            btOpenClub.translatesAutoresizingMaskIntoConstraints = false
            tempView.addSubview(btOpenClub)
            
            btOpenClub.setLeadingConstraint(withAnchor: tempView.leadingAnchor, constant: 20)
            btOpenClub.setTrailingConstraint(withAnchor: tempView.trailingAnchor, constant: -20)
            btOpenClub.setTopConstraint(withAnchor: tempView.centerYAnchor, constant: 20)
            btOpenClub.setHeightConstraint(constant: 45)
            btOpenClub.setTitle(NSLocalizedString("BtAcessar", comment: ""), for: .normal)
            btOpenClub.titleLabel?.font = BaseView.getDefatulFont(Small, bold: false)
            btOpenClub.setTitleColor(BaseView.getColor("CinzaEscuro"), for: .normal)
            btOpenClub.customizeBorderColor(BaseView.getColor("CorBtDisabled"), borderWidth: 1, borderRadius: 0)
            btOpenClub.customizeBackground(BaseView.getColor("CorBtDisabled"))
            btOpenClub.reloadCustomization()
            btOpenClub.addTarget(actionController, action:#selector(NewClubViewController.gotoClub) , for: .touchUpInside)
            btOpenClub.isEnabled = false
            
        }else{
            btGotoLogin = CustomButton()
            btGotoLogin.setNoRounedEffect()
            btGotoLogin.translatesAutoresizingMaskIntoConstraints = false
            tempView.addSubview(btGotoLogin)
            
            btGotoLogin.setLeadingConstraint(withAnchor: tempView.leadingAnchor, constant: 20)
            btGotoLogin.setTrailingConstraint(withAnchor: tempView.trailingAnchor, constant: -20)
            btGotoLogin.setBottomConstraint(withAnchor: tempView.centerYAnchor, constant: -10)
            btGotoLogin.setHeightConstraint(constant: 45)
            btGotoLogin.setTitle(NSLocalizedString("Logar", comment: ""), for: .normal)
            btGotoLogin.titleLabel?.font = BaseView.getDefatulFont(Small, bold: false)
            btGotoLogin.customizeBorderColor(BaseView.getColor("CorBotoes"), borderWidth: 1, borderRadius: 0)
            btGotoLogin.customizeBackground(BaseView.getColor("CorBotoes"))
            btGotoLogin.reloadCustomization()
            btGotoLogin.addTarget(actionController, action:#selector(NewClubViewController.gotoLogin) , for: .touchUpInside)
            
            btRegister = CustomButton()
            btRegister.setNoRounedEffect()
            btRegister.translatesAutoresizingMaskIntoConstraints = false
            tempView.addSubview(btRegister)
            
            btRegister.setLeadingConstraint(withAnchor: tempView.leadingAnchor, constant: 20)
            btRegister.setTrailingConstraint(withAnchor: tempView.trailingAnchor, constant: -20)
            btRegister.setTopConstraint(withAnchor: tempView.centerYAnchor, constant: 10)
            btRegister.setHeightConstraint(constant: 45)
            btRegister.setTitle(NSLocalizedString("Cadastrar", comment: ""), for: .normal)
            btRegister.setTitleColor(BaseView.getColor("CorBotoes"), for: .normal)
            btRegister.titleLabel?.font = BaseView.getDefatulFont(Small, bold: false)
            btRegister.customizeBorderColor(BaseView.getColor("Branco"), borderWidth: 1, borderRadius: 0)
            btRegister.customizeBackground(BaseView.getColor("Branco"))
            btRegister.addTarget(actionController, action:#selector(NewClubViewController.gotoRegister) , for: .touchUpInside)
            btRegister.reloadCustomization()
            
            
            
        }
        lblMessage.text = NSLocalizedString("Step3"+offApend, comment: "")
        lblMessage.font = BaseView.getDefatulFont(Large, bold: false)
    }
    
    
    @IBAction func onChangeAgreement(){
        if(switchAgreed.isOn){
            btOpenClub.setTitleColor(BaseView.getColor("CorBotoes"), for: .normal)
            btOpenClub.customizeBorderColor(BaseView.getColor("Branco"), borderWidth: 1, borderRadius: 0)
            btOpenClub.customizeBackground(BaseView.getColor("Branco"))
        }else{
            btOpenClub.setTitleColor(BaseView.getColor("CinzaEscuro"), for: .normal)
            btOpenClub.customizeBorderColor(BaseView.getColor("CorBtDisabled"), borderWidth: 1, borderRadius: 0)
            btOpenClub.customizeBackground(BaseView.getColor("CorBtDisabled"))
        }
        
        btOpenClub.isEnabled = switchAgreed.isOn
    }
}
