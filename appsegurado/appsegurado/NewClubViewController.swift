//
//  NewClubViewController.swift
//  appsegurado
//
//  Created by Luiz Zenha on 17/06/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation
import FontAwesome_swift

@objc class NewClubViewController : BaseViewController, UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    
    private var pageController: UIPageViewController?
    private var arrayPages:[UIViewController]!
    private var currentIndex: Int = 0
    private var btRight: UIButton!
    private var btLeft: UIButton!
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.viewDidLoad()
        self.view = UIView(frame: .zero)
        setupViewColors()
        setupPages()
        setupPageViewController()
        setupButtons()
    }
    private func setupButtons () {
        
        btRight = UIButton(type: .custom)
        btRight.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btRight)
        
        btRight.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        btRight.setTitle(String.fontAwesomeIcon(name: .angleRight), for: .normal)
        btRight.setTitleColor(BaseView.getColor("AzulEscuro"), for: .normal)
        btRight.setHeightConstraint(constant: 40)
        btRight.setWidthConstraint(constant: 40)
        
        if #available(iOS 11.0, *) {
            btRight.setBottomConstraint(withAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, constant:0)
            btRight.setTrailingConstraint(withAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        } else {
            btRight.setBottomConstraint(withAnchor: self.view.bottomAnchor, constant:0)
            btRight.setTrailingConstraint(withAnchor: self.view.trailingAnchor, constant: 0)
        }
        btRight.addTarget(self, action:#selector(NewClubViewController.clickNext) , for: .touchUpInside)
        
        btLeft = UIButton()
        btLeft.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btLeft)
        
        btLeft.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        btLeft.setTitle(String.fontAwesomeIcon(name: .angleLeft), for: .normal)
        btLeft.setTitleColor(BaseView.getColor("AzulEscuro"), for: .normal)
        btLeft.setHeightConstraint(constant: 40)
        btLeft.setWidthConstraint(constant: 40)
        
        if #available(iOS 11.0, *) {
            btLeft.setLeadingConstraint(withAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
            btLeft.setBottomConstraint(withAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        } else {
            btLeft.setLeadingConstraint(withAnchor: self.view.leadingAnchor, constant: 0)
            btLeft.setBottomConstraint(withAnchor: self.view.bottomAnchor, constant: 0)
        }
        btLeft.addTarget(self, action:#selector(NewClubViewController.clickPrevious) , for: .touchUpInside)
    }
    
    private func setupViewColors(){
        self.view.backgroundColor = BaseView.getColor("Amarelo")
        let pageControl = UIPageControl.appearance()
        pageControl.currentPageIndicatorTintColor = BaseView.getColor("AzulEscuro")
        pageControl.pageIndicatorTintColor = BaseView.getColor("Verde")
        pageControl.backgroundColor = .clear
    }
    
    private func setupPages(){
        arrayPages = []
        arrayPages.append( NewClubTutorialStep(stepIndex: 0))
        arrayPages.append( NewClubTutorialStep(stepIndex: 1))
        arrayPages.append( NewClubTutorialStep(stepIndex: 2))
        arrayPages.append( NewClubTutorialStep(stepIndex: 3, logged: false))
    }
    
    private func setupPageViewController() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        self.pageController?.setViewControllers([arrayPages[0]], direction: .forward, animated: true, completion: nil)
        self.pageController?.didMove(toParent: self)
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let currentVC = viewController as? NewClubTutorialStep else {
            return nil
        }
        var index = currentVC.step
        if index == 0 {
            return nil
        }
        
        index -= 1
        currentIndex = index
        return arrayPages[index]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? NewClubTutorialStep else {
            return nil
        }
        
        var index = currentVC.step
        if index >= arrayPages.count - 1 {
            return nil
        }
        
        index += 1
        
        return arrayPages[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentVC = pageViewController.viewControllers?[0] as? NewClubTutorialStep else {
            return
        }
        currentIndex = currentVC.step
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        if(arrayPages == nil){
            return 0
            
        }
        return arrayPages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    
    @IBAction func clickNext(){
        if(currentIndex < (arrayPages.count-1)){
            currentIndex += 1
            self.pageController?.setViewControllers([arrayPages[currentIndex]], direction: .forward, animated: true, completion: nil)
        }
    }
    @IBAction func clickPrevious(){
        if(currentIndex > 0){
            currentIndex -= 1
            self.pageController?.setViewControllers([arrayPages[currentIndex]], direction: .reverse, animated: true, completion: nil)
        }
    }
}


class NewClubTutorialStep : UIViewController {
    
    private var clubView: NewClubView!
    var step:Int = 0
    private var loggedIn:Bool = false
    
    
    init(stepIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        step = stepIndex
    }
    
    init(stepIndex: Int, logged: Bool) {
        super.init(nibName: nil, bundle: nil)
        step = stepIndex
        loggedIn = logged
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        clubView = NewClubView(frame:.	zero, stepIndex:  step, loggedIn: self.loggedIn)
        self.view = clubView;
    }
    
    
    class NewClubView: UIView {
        private var lblMessage: UILabel!
        private var imgView: UIImageView!
        private var btGotoLogin: CustomButton!
        private var loggedIn:Bool = false
        
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
           
            lblMessage.numberOfLines = 0
            lblMessage.textAlignment = .center
            lblMessage.textColor = .black
                
            if(stepIndex != 3){
                lblMessage.setLeadingConstraint(withAnchor: self.leadingAnchor, constant: 40)
                lblMessage.setTrailingConstraint(withAnchor: self.trailingAnchor, constant: -40)
                lblMessage.text = NSLocalizedString("Step"+String(stepIndex), comment: "")
                lblMessage.font = BaseView.getDefatulFont(Large, bold: false)
            }
            
            
            switch stepIndex {
                 case 1:
                    lblMessage.setTopConstraint(withAnchor: self.topAnchor, constant: 40)
                    lblMessage.setHeightConstraint(constant: 200)
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
            if(self.loggedIn){
                
            }else{
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
                
                btGotoLogin = CustomButton()
                btGotoLogin.translatesAutoresizingMaskIntoConstraints = false
                tempView.addSubview(btGotoLogin)
                
                btGotoLogin.setLeadingConstraint(withAnchor: tempView.leadingAnchor, constant: 20)
                btGotoLogin.setTrailingConstraint(withAnchor: tempView.trailingAnchor, constant: -20)
                btGotoLogin.setBottomConstraint(withAnchor: tempView.centerYAnchor, constant: -20)
                btGotoLogin.setHeightConstraint(constant: 45)
                btGotoLogin.setTitle(NSLocalizedString("Logar", comment: ""), for: .normal)
                btGotoLogin.titleLabel?.font = BaseView.getDefatulFont(Small, bold: false)
                btGotoLogin.customizeBorderColor(BaseView.getColor("CorBotoes"), borderWidth: 1, borderRadius: 0)
                btGotoLogin.customizeBackground(BaseView.getColor("CorBotoes"))
                btGotoLogin.reloadCustomization()
//
//                   [_btRegister.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
//                   [_btRegister customizeBackground:[BaseView getColor:@"Branco"]];
//                   [_btRegister setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal ];
//                   [_btRegister setTitle:NSLocalizedString(@"Cadastrar", @"") forState:UIControlStateNormal ];
//                   [_btRegister customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];

                
            }
            lblMessage.text = NSLocalizedString("Step3"+offApend, comment: "")
            lblMessage.font = BaseView.getDefatulFont(Large, bold: false)
        }
        
    }
}
