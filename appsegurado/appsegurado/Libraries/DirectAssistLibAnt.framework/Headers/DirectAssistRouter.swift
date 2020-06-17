//
//  DirectAssistRouter.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 25/06/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import UIKit
import GooglePlaces

public class DirectAssistRouter {

    fileprivate static let identifier = "DirectAssist"
    fileprivate static let storyboardName = "DirectAssist"

    public static func start() {
        if !GMSPlacesClient.provideAPIKey("AIzaSyBoV07mirQA6H5lKE1lNbo9M1XZEGsQ-o8") {
            print("ERRO - Google places")
        }
    }

    public static func callHelpScreen() -> CallHelpViewController {
        return viewController(withIdentifier: CallHelpViewController.identifier) as! CallHelpViewController
    }

    public static func locationScreen() -> LocationMapViewController {
        return viewController(withIdentifier: LocationMapViewController.identifier) as! LocationMapViewController
    }

    public static func myCasesScreen() -> MyCasesViewController {
        return viewController(withIdentifier: MyCasesViewController.identifier) as! MyCasesViewController
    }

    public static func liveHelpMapScreen() -> LiveHelpMapViewController {
        return viewController(withIdentifier: LiveHelpMapViewController.identifier) as! LiveHelpMapViewController
    }

    public static func caseScreen() -> CaseViewController {
        return viewController(withIdentifier: CaseViewController.identifier) as! CaseViewController
    }

    public static func locationSearchScreen() -> LocationSearchViewController {
        return viewController(withIdentifier: LocationSearchViewController.identifier) as! LocationSearchViewController
    }

    public static func loadingScreen() -> LoadingViewController {
        return viewController(withIdentifier: LoadingViewController.identifier) as! LoadingViewController
    }

    static func viewController(withIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: self.storyboardName, bundle: Bundle(for: self))
        return storyboard.instantiateViewController(withIdentifier: withIdentifier)
    }

}
