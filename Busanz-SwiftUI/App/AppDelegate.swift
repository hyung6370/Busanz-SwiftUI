//
//  AppDelegate.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/8/24.
//

import UIKit
import NMapsMap
import IQKeyboardManagerSwift

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        NMFAuthManager.shared().clientId = Bundle.main.NMAP_CLIENT_ID
        return true
    }
}
