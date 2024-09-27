//
//  MovieDetailsViewModel.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import SwiftUI

final class MovieDetailsViewModel: ObservableObject {
    private let repository = MovieDetailsRepository()
    @Published private(set) var details = MovieDetailsModel()
    @Published private(set) var shotLinks: [String] = []
    @Published private(set) var isNeedPresentDetails = false

    
    func loadDetails(movieId: Int) {
        repository.getMovieDetail(movieID: movieId) { [weak self] detailsDto in
            self?.details = detailsDto
            self?.isNeedPresentDetails = true
        }
        
        repository.getShots(movieId: movieId) { [weak self] shotLinks in
                self?.shotLinks = shotLinks
        }
    }
    
}
