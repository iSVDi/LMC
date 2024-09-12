//
//  MovieImageDownloader.swift
//  LMS
// 
//  Created by Daniil on 12.09.2024.
//

import Foundation
import Kingfisher


class MovieImageDownloader {
    private let cacher = ImageCache.default
    private let downloader = ImageDownloader.default
    
    func downloadImage(imageURL: String,
                       completionHandler: @escaping(Result<(image: UIImage?, stringUrl: String), Error>) -> Void ) {
        
        guard !cacher.isCached(forKey: imageURL) else {
            print("cache " + imageURL)// TODO: remove
            cacher.retrieveImage(forKey: imageURL) { res in
                switch res {
                    
                case let .success(value):
                    completionHandler(.success((value.image, imageURL)))
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            }
            return
        }
        
        print("download " + imageURL) // TODO: remove
        
        downloader.downloadImage(with: URL(string: imageURL)!) { [weak self] res in
            switch res {
                
            case let .success(loadingResult):
                self?.cacher.store(loadingResult.image, forKey: imageURL)
                completionHandler(.success((loadingResult.image, imageURL)))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
