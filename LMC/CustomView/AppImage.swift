//
//  AppImage.swift
//  LMC
//
//  Created by daniil on 25.09.2024.
//

import SwiftUI

enum AppImageTypes: String {
    case exit = "rectangle.portrait.and.arrow.right"
    case filter = "slider.vertical.3"
    case search = "magnifyingglass"
    case backward = "chevron.backward"
    case link = "link"
}

struct AppImage: View {
    private let imageName: AppImageTypes
    
    init(_ imageName: AppImageTypes) {
        self.imageName = imageName
    }
    
    var body: some View {
        Image(systemName: imageName.rawValue)
    }
}
