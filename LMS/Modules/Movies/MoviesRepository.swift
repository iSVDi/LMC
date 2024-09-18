//
//  MoviesRepository.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Moya
class MoviesRepository {
    private let moviesDataProvider = MoyaProvider<MoviesService>()
    
    func getMovies(year: Int,
                   page:Int,
                   complitionHandler: @escaping(MovieListModel) -> Void) {
        moviesDataProvider.request(.getMovies(year: year,
                                              page: page)) { result in
            if case let .success(response) = result {
                guard let movieList = try? JSONDecoder().decode(MovieListModel.self, from: response.data) else {
                    return
                }
                complitionHandler(movieList)
            }
        }
    }
    
}
