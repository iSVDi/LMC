//
//  MoviesViewController.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation
import UIKit
class MoviesViewController: AppNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
