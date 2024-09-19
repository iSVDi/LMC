//
//  MoyaService.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Moya

enum MoviesService {
    case getMovies(filter: MovieFilterDTO, page: Int)
    case getMovieDetails(id: Int)
    case getMovieShots(id: Int)
}

extension MoviesService: TargetType {
    var baseURL: URL {
        return URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2")!
    }
    
    var path: String {
        switch self {
        case .getMovies(_, _):
            return("/films")
        case .getMovieDetails(let id):
            return("/films/\(id)")
        case .getMovieShots(let id):
            return("/films/\(id)/images")
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getMovies(let filter, let page):
            var params: [String: Any] = ["order" : filter.getOrder(),
                                         "page": page]
            if case let .year(year) = filter {
                params["yearFrom"] = year
                params["yearTo"] = year
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getMovieDetails(_):
            return .requestPlain
        case .getMovieShots(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "X-API-KEY": "ea499c08-37e5-4a7d-976d-916cf7cdde35",
            //            "X-API-KEY": "8b7f7ac2-57f0-4895-886e-cd3e1abdf953",
            "Content-Type": "application/json",
            
        ]
    }
    
}
