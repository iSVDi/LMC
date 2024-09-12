//
//  MovieTableViewCell.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    private var movie: MovieListItemModel?
    private let movieImageView = UIImageView()
    private let nameLabel = UILabel()
    private let genreLabel = UILabel()
    private let yearContriesLabel = UILabel()
    private let ratingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: MovieListItemModel) {
        // TODO: add kingfisher
//        movieImageView.image
        nameLabel.text = data.nameOriginal
        genreLabel.text = data.genres
            .map{$0.genre}
            .joined(separator: ", ")
        yearContriesLabel.text = "\(data.year), " + data.countries
            .map{$0.country}
            .joined(separator: ", ")
        ratingLabel.text = "\(data.ratingKinopoisk)"
    }
    
    private func setupLayout() {
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        let detailsStack = UIStackView()
        detailsStack.axis = .vertical
        
        mainStack.backgroundColor = .red
        detailsStack.backgroundColor = .blue
        
        [movieImageView, detailsStack].forEach { subview in
            mainStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        
        movieImageView.leftToSuperview()
        mainStack.setCustomSpacing(10, after: movieImageView)
        detailsStack.rightToSuperview()
        
        [nameLabel, genreLabel, yearContriesLabel, ratingLabel].forEach {subview in
            detailsStack.addArrangedSubview(subview)
            subview.horizontalToSuperview()
        }
        
        contentView.addSubview(mainStack)
        mainStack.edgesToSuperview()
    }
    
    private func setupViews() {
        //TODO: implement
    }
    
    
    
}
