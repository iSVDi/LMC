//
//  MoviesRepository.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Moya
class MoviesRepository {
    private let moviesDataProvider = MoyaProvider<MoviesService>()
    
    func getMovies(order: MoviesOrder, year: Int, complitionHandler: @escaping(MovieListModel) -> Void) {
        moviesDataProvider.request(.getMovies(order: order, year: year)) { result in
            switch result {
            case let .success(response):
                guard let movieList = try? JSONDecoder().decode(MovieListModel.self, from: response.data) else {
                    //TODO: handle
                    return
                }
                complitionHandler(movieList)
                
            case let .failure(error): break
                //TODO: handle error
            }
        }
    }
    
    
}

