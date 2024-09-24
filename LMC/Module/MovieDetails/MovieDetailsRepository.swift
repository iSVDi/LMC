//
//  MovieDetailsRepository.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import Moya
final class MovieDetailsRepository {
    private let dataProvider = MoyaProvider<MoviesService>()
    
    func getMovieDetail(movieID: Int, completionHandler: @escaping (MovieDetailsModel) -> Void) {
        dataProvider.request(.getMovieDetails(id: movieID)) { res in
            if case let .success(response) = res {
                guard let movieDetail = try? JSONDecoder().decode(MovieDetailsDTO.self, from: response.data) else {
                    return
                }
                completionHandler(movieDetail.getModel())
            }
            
        }
    }
    
    func getShots(movieId: Int, completionHandler: @escaping ([String]) -> Void) {
        dataProvider.request(.getMovieShots(id: movieId)) { res in
            if case let .success(response) = res {
                guard let shotList =
                        try? JSONDecoder().decode(MovieShotSourceListDTO.self, from: response.data) else {
                    return
                }
                let urls = shotList.items.map{$0.previewURL}
                completionHandler(urls)
            }
        }
    }
}
