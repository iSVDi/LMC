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
    case sort = "arrow.up.arrow.down"
    
    func systemImage() -> UIImage? {
        return UIImage(systemName: self.rawValue) ?? nil
    }
}

