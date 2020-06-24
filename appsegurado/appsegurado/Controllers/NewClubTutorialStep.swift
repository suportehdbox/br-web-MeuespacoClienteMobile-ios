//
//  NewClubTutorialStep.swift
//  appsegurado
//
//  Created by Luiz Zenha on 22/06/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation


class NewClubTutorialStep : UIViewController {
    
    private var clubView: NewClubView!
    var step:Int = 0
    private var loggedIn:Bool = false
    private var actionController:NewClubViewController!
    
    
    
    init(stepIndex: Int, actionController: NewClubViewController) {
        super.init(nibName: nil, bundle: nil)
        self.actionController = actionController
        step = stepIndex
    }
    
    init(stepIndex: Int, actionController: NewClubViewController, logged: Bool) {
        super.init(nibName: nil, bundle: nil)
        step = stepIndex
        self.actionController = actionController
        loggedIn = logged
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        clubView = NewClubView(frame:.    zero, stepIndex:  step, loggedIn: self.loggedIn)
        clubView.actionController = actionController
        self.view = clubView;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (self.view as? NewClubView)!.adjustLayout()
    }
}
