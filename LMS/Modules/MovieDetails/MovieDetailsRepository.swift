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
            if case let .success(response) = res {
                guard let movieDetail = try? JSONDecoder().decode(MovieDetailsModel.self, from: response.data) else {
                    return
                }
                completionHandler(movieDetail)
            }
            
        }
    }
    
    func getShots(movieId: Int, completionHandler: @escaping (MovieShotSourceListModel) -> Void) {
        dataProvider.request(.getMovieShots(id: movieId)) { res in
            if case let .success(response) = res {
                guard let shotList =
                        try? JSONDecoder().decode(MovieShotSourceListModel.self, from: response.data) else {
                    return
                }
                completionHandler(shotList)
            }
        }
    }
}
