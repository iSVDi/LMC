//
//  MoviesRepository.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import Moya
final class MoviesRepository {
    private let moviesDataProvider = MoyaProvider<MoviesService>()
    
    func getMovies(
        filter: MovieFilterDTO,
        page:Int,
        complitionHandler: @escaping (MovieListDTO) -> Void
    ) {
        moviesDataProvider.request(.getMovies(filter: filter, page: page)) { result in
            if case let .success(response) = result {
                /* CODEREVIEW:
                 Настрой в Xcode лимит строки в 120 символов.
                 И стоит тогда переносы делать, если утыкаешься в него

                 Xcode -> Settings -> Text Editing -> Display -> Page guide at column -> галочка и 120
                 */
                guard let movieList = try? JSONDecoder().decode(MovieListDTO.self, from: response.data) else {
                    return
                }
                complitionHandler(movieList)
            }
        }
    }
    
}

