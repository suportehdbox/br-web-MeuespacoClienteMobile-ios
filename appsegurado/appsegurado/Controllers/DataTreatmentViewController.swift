//
//  DataTreatmentViewController.swift
//  appsegurado
//
//  Created by Luiz Othavio H Zenha on 03/08/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation

class DataTreatmentViewController : BaseViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("TratamentoDados", comment: "");
        
        
        if(self.navigationController?.viewControllers.first == self){
            super.addLeftMenu()
        }
        
        self.view = DataTreatmentView(frame: .zero, controller: self)
        
    }
    @objc func OpenLink(button: UIButton){
        super.openLGPDSite(button)
    }

}

class DataTreatmentView: BaseView {
    let bgCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = BaseView.getColor("CinzaTexto")
        lbl.font = BaseView.getDefatulFont(XLarge, bold: true)
        lbl.text = NSLocalizedString("TratamentoDados", comment: "")
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let btMessage: UIButton = {
        let bt = UIButton()
        bt.titleLabel?.baselineAdjustment = .alignCenters
        bt.setTitleColor(BaseView.getColor("CinzaTexto"), for: .normal)
        bt.titleLabel?.numberOfLines = 0
        bt.titleLabel?.adjustsFontSizeToFitWidth = true
        bt.titleLabel?.minimumScaleFactor = 0.5
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = BaseView.getColor("Amarelo")
        button.setTitleColor(BaseView.getColor("AzulEscuro"), for: .normal)
        button.titleLabel?.font = BaseView.getDefatulFont(Medium, bold: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.setTitle(NSLocalizedString("AcessarCanal", comment: ""), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    @objc public init(frame: CGRect, controller: DataTreatmentViewController) {
        super.init(frame: frame)
        
        self.backgroundColor = BaseView.getColor("CinzaFundo")
        
        
        adjustPostionSubviews()
        
        btMessage.setAttributedTitle(getLGPDText(Medium), for: .normal)
        btMessage.addTarget(controller, action:#selector(DataTreatmentViewController.OpenLink), for: .touchUpInside)
        button.addTarget(controller, action:#selector(DataTreatmentViewController.OpenLink), for: .touchUpInside)
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func adjustPostionSubviews(){
        
        self.addSubview(bgCard)
        bgCard.setLeadingConstraint(withAnchor: self.leadingAnchor, constant: 15)
        bgCard.setTrailingConstraint(withAnchor: self.trailingAnchor, constant: -15)
        bgCard.setTopConstraint(withAnchor: self.topAnchor, constant: 15)
        bgCard.setMinimumHeight(constant: 400)
        
        bgCard.addSubview(lblTitle)
        
        lblTitle.setLeadingConstraint(withAnchor: bgCard.leadingAnchor, constant: 15)
        lblTitle.setTrailingConstraint(withAnchor: bgCard.trailingAnchor, constant: -15)
        lblTitle.setTopConstraint(withAnchor: bgCard.topAnchor, constant: 20)
        lblTitle.setHeightConstraint(constant: 35)
        
        bgCard.addSubview(btMessage)
        
        btMessage.setLeadingConstraint(withAnchor: bgCard.leadingAnchor, constant: 15)
        btMessage.setTrailingConstraint(withAnchor: bgCard.trailingAnchor, constant: -15)
        btMessage.setTopConstraint(withAnchor: lblTitle.bottomAnchor, constant: 20)
        
        
        bgCard.addSubview(button)
        button.setLeadingConstraint(withAnchor: bgCard.leadingAnchor, constant: 15)
        button.setTrailingConstraint(withAnchor: bgCard.trailingAnchor, constant: -15)
        button.setHeightConstraint(constant: 45)
        button.setBottomConstraint(withAnchor: bgCard.bottomAnchor, constant: -20)
        if(Config.isAliroProject()){
             button.setTitleColor(BaseView.getColor("Branco"), for: .normal)
         }
        btMessage.setBottomConstraint(withAnchor: button.topAnchor, constant: -20)
    }
    
}
