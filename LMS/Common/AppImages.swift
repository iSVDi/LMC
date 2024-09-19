//
//  AppImages.swift
//  LMS
//
//  Created by Daniil on 14.09.2024.
//

import UIKit

enum AppImage: String {
    case link = "link"
    case search = "magnifyingglass"
    case exit = "rectangle.portrait.and.arrow.right"
    case filter = "slider.vertical.3"
    
    func systemImage() -> UIImage? {
        return UIImage(systemName: self.rawValue) ?? nil
    }
}

