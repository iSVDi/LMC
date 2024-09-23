//
//  MovieShotSourceListDTO.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Foundation

// MARK: - MovieShotSourceListModel
struct MovieShotSourceListDTO: Codable {
    let items: [MovieImageShotSourceModel]
}

// MARK: - MovieImageShotSourceModel
struct MovieImageShotSourceModel: Codable {
    let imageURL, previewURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case previewURL = "previewUrl"
    }
}

