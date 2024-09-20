//
//  MoviesRepository.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import Moya
class MoviesRepository {
    private let moviesDataProvider = MoyaProvider<MoviesService>()
    
    func getMovies(filter: MovieFilterDTO,
                   page:Int,
                   complitionHandler: @escaping(MovieListDTO) -> Void) {
        moviesDataProvider.request(.getMovies(filter: filter,
                                              page: page)) { result in
            if case let .success(response) = result {
                guard let movieList = try? JSONDecoder().decode(MovieListDTO.self, from: response.data) else {
                    return
                }
                complitionHandler(movieList)
            }
        }
    }
    
}

