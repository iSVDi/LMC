//
//  MovieDetailsViewController.swift
//  LMS
//
//  Created by Daniil on 12.09.2024.
//

import UIKit

protocol MovieDetailsDelegate: AnyObject {
    func setMovieDetails(_ movieDetails: MovieDetailsModel)
    func setShots(_ shots: [UIImage?])
}

class MovieDetailsViewController: UIViewController, MovieDetailsDelegate {
    private let shotStackHeight: CGFloat = 140
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    private let descritionLabel = UILabel()
    private let genreLabel = UILabel()
    private let yearsCounryLabel = UILabel()
    private let shotTitleLabel = UILabel()
    private let shotHScrollView = UIScrollView()
    private let linkButton = UIButton()
    private var activityView = UIActivityIndicatorView()
    
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
        titleLabel.text = movieDetails.getName()
        ratingLabel.text = movieDetails.ratingKinopoisk != nil ? "\(movieDetails.ratingKinopoisk!)" : ""
        descriptionTitleLabel.text = AppStrings.descriptionTitle
        descritionLabel.text = movieDetails.description
        genreLabel.text = movieDetails.genres.map{$0.genre}.joined(separator: ", ")
        
        let years = movieDetails.getYearTitle()
        let countries = movieDetails.countries.map{$0.country}.joined(separator: ", ")
        yearsCounryLabel.text = years + countries
        shotTitleLabel.text = AppStrings.shotsTitle
        
        setupSubviewsIsHidden(false)
        activityView.stopAnimating()
        
        guard let imageURL = movieDetails.coverURL else {
            return
        }
        
        movieImageDownloader.downloadImage(imageURL: imageURL) { [weak self] res in
            if case let .success((resImage, _)) = res {
                self?.imageView.image = resImage
            }
        }
    }
    
    func setShots(_ shots: [UIImage?]) {
        let imageViews = shots.map { image in
            let shotImageView = UIImageView()
            shotImageView.image = image
            shotImageView.contentMode = .scaleAspectFit
            shotImageView.widthToHeight(of: shotImageView, multiplier: 1.1)
            return shotImageView
        }
        shotTitleLabel.isHidden = false
        shotHScrollView.isHidden = false
        shotHScrollView.stack(imageViews, axis: .horizontal, height: shotStackHeight, spacing: 10)
    }
    
    private func setupLayout() {
        let mainScroll = UIScrollView()
        let imageSection = getImageSection()
        let descriptionSection = getDescriptionSection()
        let shotsSection = getShotsSection()
        mainScroll.stack([imageSection, descriptionSection, shotsSection], axis: .vertical, spacing: 20)
        
        view.addSubview(mainScroll)
        mainScroll.contentInsetAdjustmentBehavior = .never
        mainScroll.edgesToSuperview()
        
        shotTitleLabel.isHidden = true
        shotHScrollView.isHidden = true
        
        view.addSubview(activityView)
        activityView.edgesToSuperview()
    }
    
    private func getImageSection() -> UIView {
        let wrapper = UIView()
        let titleSection = getTitleSection()
        [imageView, titleSection].forEach { subview in
            wrapper.addSubview(subview)
        }
        imageView.edgesToSuperview()
        imageView.width(view.frame.width)
        imageView.heightToWidth(of: imageView)
        titleSection.horizontalToSuperview(insets: .horizontal(16))
        titleSection.bottomToSuperview(offset: -10)
        return wrapper
    }
    
    private func getTitleSection() -> UIView {
        let titleRatingStack = UIStackView()
        titleRatingStack.axis = .horizontal
        titleRatingStack.distribution = .fillProportionally
        [titleLabel, ratingLabel].forEach { subview in
            titleRatingStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        
        return titleRatingStack
    }
    
    private func getDescriptionSection() -> UIView {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 10
        sectionStack.alignment = .center
        let titleButtonStack = UIStackView()
        titleButtonStack.distribution = .fillProportionally
        titleButtonStack.axis = .horizontal
        [descriptionTitleLabel, linkButton].forEach { subview in
            titleButtonStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        descriptionTitleLabel.leftToSuperview()
        linkButton.rightToSuperview()
        
        [titleButtonStack, descritionLabel, genreLabel, yearsCounryLabel].forEach { subview in
            
            sectionStack.addArrangedSubview(subview)
            subview.horizontalToSuperview(insets: .horizontal(16))
        }
        
        return sectionStack
    }
    
    private func getShotsSection() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        
        [shotTitleLabel, shotHScrollView].forEach { subview in
            stack.addArrangedSubview(subview)
            subview.horizontalToSuperview()
        }
        shotHScrollView.height(shotStackHeight)
        
        let wrapper = UIView()
        wrapper.addSubview(stack)
        stack.edgesToSuperview(insets: .horizontal(16))
        return wrapper
    }
    
    private func setupViews() {
        view.backgroundColor = AppColors.appBlack
        activityView.color = AppColors.appColor
        activityView.startAnimating()
        setupSubviewsIsHidden(true)
        
        navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
        imageView.contentMode = .scaleAspectFit
        
        [titleLabel, descriptionTitleLabel, descritionLabel, shotTitleLabel].forEach { label in
            label.textColor = AppColors.appWhite
        }
        genreLabel.textColor = AppColors.appGray
        yearsCounryLabel.textColor = AppColors.appGray
        ratingLabel.textColor = AppColors.appColor
        ratingLabel.textAlignment = .right
        
        linkButton.setImage(AppImage.link.systemImage(), for: .normal)
        linkButton.tintColor = AppColors.appColor
        linkButton.addTarget(self, action: #selector(linkButtonHandler), for: .touchUpInside)
        
        titleLabel.font = AppFonts.Roboto.bold.font(size: 25)
        ratingLabel.font = AppFonts.Roboto.bold.font(size: 25)
        
        descriptionTitleLabel.font = AppFonts.Roboto.bold.font(size: 30)
        descritionLabel.font = AppFonts.Roboto.bold.font(size: 17)
        descritionLabel.numberOfLines = 0
        
        genreLabel.font = AppFonts.Roboto.bold.font(size: 17)
        yearsCounryLabel.font = AppFonts.Roboto.bold.font(size: 17)
        shotTitleLabel.font = AppFonts.Roboto.bold.font(size: 30)
        
        [titleLabel, ratingLabel, descritionLabel, genreLabel, yearsCounryLabel].forEach {$0.adjustsFontSizeToFitWidth = true}
        
    }
    
    private func setupSubviewsIsHidden(_ isHidden: Bool) {
        [imageView, titleLabel,ratingLabel,descriptionTitleLabel,descritionLabel,genreLabel,yearsCounryLabel, linkButton].forEach { subview in
            subview.isHidden = isHidden
        }
    }
    
    //    MARK: - handlers
    @objc
    private func linkButtonHandler() {
        guard let stringUrl = presenter?.webUrlString,
        let url = URL(string: stringUrl) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
}
