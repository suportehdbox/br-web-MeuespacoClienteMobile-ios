//
//  DirectAssist.swift
//  DirectAssistLib
//
//  Created by Gustavo Graña on 26/07/17.
//  Copyright © 2017 DirectAssist. All rights reserved.
//

import Foundation

public class DirectAssist {

    public static var cpf: String? {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "DirectAssistCPF")
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "DirectAssistCPF")
        }
    }

    public static var chassi: String? {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "DirectAssistChassi")
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "DirectAssistChassi")
        }
    }
    
    public static var plate: String? {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "DirectAssistPlate")
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "DirectAssistPlate")
        }
    }

    public static var phone: String? {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "DirectAssistPhone")
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "DirectAssistPhone")
        }
    }

}
