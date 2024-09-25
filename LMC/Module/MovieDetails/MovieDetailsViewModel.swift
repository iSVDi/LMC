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
    /* CODEREVIEW:
     В принципе тут можно было бы не заводить доп флажки, а напрямую положиться на свойство details

     Его можно сделать опциональным, и если оно nil - то показываешь прогресс на вьюхе,
     если нет - контент

     Для проверки, нужно ли показывать кадры - можно напрямую завязаться на массив shotLinks во вьюхе
     */
    @Published private(set) var isNeedPresentDetails = false
    @Published private(set) var isNeedPresentShots = false
    @Published private(set) var isNeedPresentShotsProgressView = true
    
    func loadDetails(movieId: Int) {
        repository.getMovieDetail(movieID: movieId) { [weak self] detailsDto in
            self?.details = detailsDto
            self?.isNeedPresentDetails = true
        }
        
        repository.getShots(movieId: movieId) { [weak self] shotLinks in
                self?.shotLinks = shotLinks
            self?.isNeedPresentShots = !shotLinks.isEmpty
            self?.isNeedPresentShotsProgressView = false
        }
    }
    
}
