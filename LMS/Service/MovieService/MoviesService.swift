//
//  MoyaService.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Moya

enum MoviesOrder: String {
    case rating = "RATING"
    case year = "YEAR"
}

enum MoviesService {
    case getMovies(order: MoviesOrder)
    case getMovieDetails(id: Int)
    case getMovieShots(id: Int)
}

extension MoviesService: TargetType {
    var baseURL: URL {
        return URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2")!
    }
    
    var path: String {
        switch self {
        case .getMovies(let order):
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
        case .getMovies(let order):
            return .requestParameters(parameters: ["order" : order.rawValue], encoding: URLEncoding.queryString)
        case .getMovieDetails(let id):
            return .requestPlain
        case .getMovieShots(let id):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "X-API-KEY": "ea499c08-37e5-4a7d-976d-916cf7cdde35",
            "Content-Type": "application/json",
            
        ]
    }
    
    
}
