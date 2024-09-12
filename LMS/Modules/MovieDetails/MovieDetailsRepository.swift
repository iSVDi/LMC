//
//  MovieDetailsRepository.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Moya
class MovieDetailsRepository {
    private let dataProvider = MoyaProvider<MoviesService>()
    
    func getMovieDetail(movieID: Int, completionHandler: @escaping (MovieDetailsModel) -> Void) {
        dataProvider.request(.getMovieDetails(id: movieID)) { res in
            switch res {
                
            case let .success(response):
                
                //TODO: Handle wrong work
                guard let movieDetail = try? JSONDecoder().decode(MovieDetailsModel.self, from: response.data) else {
                    print()
                    return //TODO: handle
                }
                completionHandler(movieDetail)
            case let .failure(error):
                print(error.localizedDescription)
                //TODO: handle
            }
        }
    }
    
    func getShots(movieId: Int, completionHandler: @escaping (MovieShotSourceListModel) -> Void) {
        dataProvider.request(.getMovieShots(id: movieId)) { res in
            switch res {
                
            case let .success(response):
                guard let shotList =
                        try? JSONDecoder().decode(MovieShotSourceListModel.self, from: response.data) else {
                    // TODO: handle
                    return
                }
                
            case let .failure(error):
                print()
                // TODO: handle
            }
        }
    }
}
