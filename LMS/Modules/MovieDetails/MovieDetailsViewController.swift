//
//  MovieDetailsViewController.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import UIKit

protocol MovieDetailsDelegate: AnyObject {
    func setMovieDetails(_ movieDetails: MovieDetailsModel)
    func setShots(_ shots: [UIImage])
}

class MovieDetailsViewController: UIViewController, MovieDetailsDelegate {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    private let descritionLabel = UILabel()
    private let genraLabel = UILabel()
    private let yearsCounryLabel = UILabel()
    private let shotTitleLabel = UILabel()
    private let shotHScrollView = UIScrollView()
    private let movieImageDownloader = MovieImageDownloader()
    private var presenter: MovieDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupViews()
        presenter?.handleViewDidLoad()
    }
    
    func setPresent(_ presenter: MovieDetailsPresenter) {
        self.presenter = presenter
    }
    
    func setMovieDetails(_ movieDetails: MovieDetailsModel) {
        movieImageDownloader.downloadImage(imageURL: movieDetails.coverURL) { [weak self] res in
            switch res {
            case .success((let image, _)):
                self?.imageView.image = image
            case .failure(_): break
                //TODO: handle
            }
        }
        
        titleLabel.text = movieDetails.nameOriginal
        ratingLabel.text = "\(movieDetails.ratingKinopoisk)"
        descriptionTitleLabel.text = "Описание" // TODO: localize
        descritionLabel.text = movieDetails.description
        genraLabel.text = movieDetails.genres.map{$0.genre}.joined(separator: ", ")
        
        let years = "\(movieDetails.startYear) - \(movieDetails.endYear), "
        let countries = movieDetails.countries.map{$0.country}.joined(separator: ", ")
        yearsCounryLabel.text = years + countries
        shotTitleLabel.text = "Кадры" //TODO: localize
    }
    
    func setShots(_ shots: [UIImage]) {
        let imageViews = shots.map { image in
            let shotImageView = UIImageView()
            shotImageView.image = image
            shotImageView.size(.init(width: 100, height: 50))
            return shotImageView
        }
        shotHScrollView.stack(imageViews, axis: .horizontal)
    }

    private func setupLayout() {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        
        let imageSection = getImageSection()
        let descriptionSection = getDescriptionSection()
        let shotsSection = getShotsSection()
        
        
        [imageSection, descriptionSection, shotsSection].forEach { subview in
            mainStack.addArrangedSubview(subview)
            
        }
        
        view.addSubview(mainStack)
        mainStack.edgesToSuperview(excluding: .bottom)
    }
    
    private func getImageSection() -> UIView {
        let wrapper = UIView()
        let titleSection = getTitleSection()
        [imageView, titleSection].forEach { subview in
            wrapper.addSubview(subview)
        }
        imageView.edgesToSuperview()
        imageView.heightToWidth(of: imageView)
        titleSection.edgesToSuperview(excluding: .top, insets: .horizontal(16))
        return wrapper
    }
    
    private func getTitleSection() -> UIView {
        let titleRatingStack = UIStackView()
        titleRatingStack.axis = .horizontal
        [titleLabel, ratingLabel].forEach { subview in
            titleRatingStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        titleLabel.leftToSuperview()
        ratingLabel.rightToSuperview()
        return titleRatingStack
    }
    
    private func getDescriptionSection() -> UIView {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        [descriptionTitleLabel, descritionLabel, genraLabel, yearsCounryLabel].forEach { label in
            sectionStack.addArrangedSubview(label)
            label.horizontalToSuperview(insets: .horizontal(16))
        }
        
        return sectionStack
    }
    
    private func getShotsSection() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        [shotTitleLabel, shotHScrollView].forEach { subview in
            stack.addArrangedSubview(subview)
            subview.horizontalToSuperview(insets: .horizontal(16))
        }
        
        return stack
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFit
        descritionLabel.numberOfLines = 0
        
        [titleLabel, descriptionTitleLabel, descritionLabel, genraLabel, yearsCounryLabel, shotTitleLabel].forEach { label in
            label.textColor = AppColors.appWhite
        }
        
        ratingLabel.textColor = AppColors.appColor
    }
    

}
