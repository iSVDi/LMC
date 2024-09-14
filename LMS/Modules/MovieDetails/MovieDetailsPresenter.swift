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
    private(set) var webUrlString: String?
    
    init(movieID: Int, movieDetailsDelegate: MovieDetailsDelegate) {
        self.movieID = movieID
        self.movieDetailsDelegate = movieDetailsDelegate
    }
    
    func handleViewDidLoad() {
        repository.getMovieDetail(movieID: movieID) { [weak self] movieDetails in
            self?.webUrlString = movieDetails.webUrl
            self?.movieDetailsDelegate?.setMovieDetails(movieDetails)
        }
        
        repository.getShots(movieId: movieID) { [weak self] shotList in
            let imageUrlList = shotList.items.map{$0.previewURL}
            self?.loadImages(imageUrlList: imageUrlList) { [weak self] images in
                if !images.isEmpty {
                    self?.movieDetailsDelegate?.setShots(images)
                }
                
            }
        }
        
    }
    
    private func loadImages(imageUrlList: [String], completion: @escaping ([UIImage?]) -> Void) {
        var images: [UIImage?] = []
        let dispatchGroup = DispatchGroup()
        
        imageUrlList.forEach { [weak self] shotStringUrl in
            dispatchGroup.enter()
            self?.movieImageDownloader.downloadImage(imageURL: shotStringUrl) { (res: Result<(image: UIImage?, stringUrl: String), Error>) in
                defer { dispatchGroup.leave() }
                if case let .success((image, _)) = res {
                    images.append(image)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }
    
}
