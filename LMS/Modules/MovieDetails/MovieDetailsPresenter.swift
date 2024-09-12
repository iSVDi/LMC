//
//  MovieDetailsPresenter.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import Foundation
import UIKit
class MovieDetailsPresenter {
    private let movieID: Int
    private weak var movieDetailsDelegate: MovieDetailsDelegate?
    private let repository = MovieDetailsRepository()
    private let movieImageDownloader = MovieImageDownloader()
    
    init(movieID: Int, movieDetailsDelegate: MovieDetailsDelegate) {
        self.movieID = movieID
        self.movieDetailsDelegate = movieDetailsDelegate
    }
    
    func handleViewDidLoad() {
        repository.getMovieDetail(movieID: movieID) { [weak self] movieDetails in
            self?.movieDetailsDelegate?.setMovieDetails(movieDetails)
        }
        
        //TODO: implement
//        repository.getShots(movieId: movieID) { [weak self] shotList in
//            let imageUrlList = shotList.items.map{$0.previewURL}
//            self?.loadImages(imageUrlList: imageUrlList)
//        }
        
    }
    
//    private func loadImages(imageUrlList: [String]) {
//        
//        var images: [UIImage] = []
//        imageUrlList.forEach { [weak self] shotStringUrl in
//            self?.movieImageDownloader.downloadImage(imageURL: shotStringUrl) { [weak self] res in
//                switch res {
//                case let .success(( image, _)):
//                    images.append(image)
//                case let .failure(error):
//                    print() //TODO: handle
//                }
//            }
//        }
//    }
    
}
