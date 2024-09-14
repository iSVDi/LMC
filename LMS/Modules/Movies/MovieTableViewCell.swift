//
//  MovieTableViewCell.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    private var movie: MovieListItemModel?
    private let movieImageView = UIImageView()
    private let nameLabel = UILabel()
    private let genreLabel = UILabel()
    private let yearContriesLabel = UILabel()
    private let ratingLabel = UILabel()
    private let imageDownloader = MovieImageDownloader()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
    
    //TODO: refactoring
    func setData(_ data: MovieListItemModel) {
        imageDownloader.downloadImage(imageURL: data.posterURLPreview) { [weak self] res in
            switch res {
            case let .success(value):
                
                guard data.posterURLPreview == value.stringUrl else {
                    return
                }
                self?.movieImageView.image = value.image
            case let .failure(error): break
            }
        }
        
        nameLabel.text = data.getName
        genreLabel.text = data.genres
            .map{$0.genre}
            .joined(separator: ", ")
        yearContriesLabel.text = "\(data.year), " + data.countries
            .map{$0.country}
            .joined(separator: ", ")
        ratingLabel.text = data.ratingKinopoisk != nil ? "\(data.ratingKinopoisk!)" : ""
    }
    
    private func setupLayout() {
        let mainStack = UIStackView()
        let detailsStack = UIStackView()
        mainStack.axis = .horizontal
        detailsStack.axis = .vertical
        detailsStack.distribution = .fillEqually
        [movieImageView, detailsStack].forEach { subview in
            mainStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        
        movieImageView.leftToSuperview()
        movieImageView.size(CGSize(width: 100, height: 100))
        mainStack.setCustomSpacing(15, after: movieImageView)
        detailsStack.rightToSuperview()
        
        [nameLabel, genreLabel, yearContriesLabel, ratingLabel].forEach {subview in
            detailsStack.addArrangedSubview(subview)
            subview.horizontalToSuperview()
        }
        
        contentView.addSubview(mainStack)
        mainStack.edgesToSuperview(excluding: .bottom)
        mainStack.height(100)
    }
    
    private func setupViews() {
        backgroundColor = AppColors.appClear
        [nameLabel, genreLabel, yearContriesLabel, ratingLabel].forEach { label in
            label.textColor = AppColors.appWhite
        }
        ratingLabel.textAlignment = .right
        ratingLabel.textColor = AppColors.appColor
        
        nameLabel.font = AppFonts.Roboto.bold.font(size: 20)
        genreLabel.font = AppFonts.Roboto.bold.font(size: 15)
        genreLabel.textColor = AppColors.appGray
        yearContriesLabel.textColor = AppColors.appGray
        yearContriesLabel.font = AppFonts.Roboto.bold.font(size: 15)
        ratingLabel.font = AppFonts.Roboto.bold.font(size: 20)
        
    }
    
}
