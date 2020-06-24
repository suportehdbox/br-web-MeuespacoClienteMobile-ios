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
    private var btRight: UIButton?
    private var btLeft: UIButton?
    private let appDelegate:AppDelegate! = UIApplication.shared.delegate as? AppDelegate
    private let model:ClubModel! = ClubModel()
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func loadView() {
        super.viewDidLoad()
        self.view = UIView(frame: .zero)
        if(self.model.getAlreadyAgreed()){
            self.view.backgroundColor = .white
            gotoClub()
        }else{
            setupViewColors()
            setupPages()
            setupPageViewController()
            setupButtons()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.navigationController?.viewControllers.first == self){
            super.addLeftMenu()
        }
        self.title = NSLocalizedString("ClubeVantagens", comment: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    private func setupButtons () {
        
        btRight = UIButton(type: .custom)
        btRight?.translatesAutoresizingMaskIntoConstraints = false
        if(btRight != nil){
            self.view.addSubview(btRight!)
        }
        
        btRight?.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        btRight?.setTitle(String.fontAwesomeIcon(name: .angleRight), for: .normal)
        btRight?.setTitleColor(BaseView.getColor("AzulEscuro"), for: .normal)
        btRight?.setHeightConstraint(constant: 40)
        btRight?.setWidthConstraint(constant: 40)
        
        if #available(iOS 11.0, *) {
            btRight?.setBottomConstraint(withAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, constant:0)
            btRight?.setTrailingConstraint(withAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        } else {
            btRight?.setBottomConstraint(withAnchor: self.view.bottomAnchor, constant:0)
            btRight?.setTrailingConstraint(withAnchor: self.view.trailingAnchor, constant: 0)
        }
        btRight?.addTarget(self, action:#selector(NewClubViewController.clickNext) , for: .touchUpInside)
        
        btLeft = UIButton()
        btLeft?.translatesAutoresizingMaskIntoConstraints = false
        if(btLeft != nil){
            self.view.addSubview(btLeft!)
        }
        btLeft?.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        btLeft?.setTitle(String.fontAwesomeIcon(name: .angleLeft), for: .normal)
        btLeft?.setTitleColor(BaseView.getColor("AzulEscuro"), for: .normal)
        btLeft?.setHeightConstraint(constant: 40)
        btLeft?.setWidthConstraint(constant: 40)
        
        if #available(iOS 11.0, *) {
            btLeft?.setLeadingConstraint(withAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
            btLeft?.setBottomConstraint(withAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        } else {
            btLeft?.setLeadingConstraint(withAnchor: self.view.leadingAnchor, constant: 0)
            btLeft?.setBottomConstraint(withAnchor: self.view.bottomAnchor, constant: 0)
        }
        btLeft?.addTarget(self, action:#selector(NewClubViewController.clickPrevious) , for: .touchUpInside)
        btLeft?.isHidden = true
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
        arrayPages.append( NewClubTutorialStep(stepIndex: 0, actionController: self))
        arrayPages.append( NewClubTutorialStep(stepIndex: 1, actionController: self))
        arrayPages.append( NewClubTutorialStep(stepIndex: 2, actionController: self))
        arrayPages.append( NewClubTutorialStep(stepIndex: 3, actionController: self, logged: appDelegate.isUserLogged()))
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
        updateButtons()
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        if(arrayPages == nil){
            return 0
            
        }
        return arrayPages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        updateButtons()
        return currentIndex
    }
    
    private func updateButtons(){
        btLeft?.isHidden = false
        btRight?.isHidden = false
        if(currentIndex == 0){
            btLeft?.isHidden = true
        }else if(currentIndex == arrayPages.count-1){
            btRight?.isHidden = true
        }
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
    
    @IBAction func gotoLogin(){
        appDelegate.gotoLoginView = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotoRegister(){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gotoTerms(){
        self.openTerms()
    }
    @IBAction func gotoClub(){
        self.model.setAgreedTerms()
        let wvClub:NewClubWebViewController = NewClubWebViewController()
        if(self.navigationController?.viewControllers.first == self){
            //Replace when loaded from side menu
            self.navigationController?.setViewControllers([wvClub], animated: true)
        }else{
            //Replace current view controller when loaded from a history of view controllers
            if var viewControllers = self.navigationController?.viewControllers {
                viewControllers[viewControllers.count - 1] = wvClub
                navigationController?.viewControllers = viewControllers
            }
        }
        
    }
    
}

