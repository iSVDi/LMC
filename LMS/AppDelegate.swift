//
//  AppDelegate.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let authService = AuthService()
        let controller = authService.getController()
        window?.rootViewController = controller
        return true
    }
    
    
    
    
}

