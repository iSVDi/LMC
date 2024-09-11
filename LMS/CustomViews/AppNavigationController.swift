//
//  AppNavigationController.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
    }
}
