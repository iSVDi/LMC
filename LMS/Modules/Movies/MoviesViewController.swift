//
//  MoviesViewController.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation
import UIKit

protocol MoviesViewControllerDelegate: AnyObject {
    func presentController(_ controller: UIViewController)
    func reloadTableView()
    func pushController(_ controller: UIViewController)
    func setLoading(_ state: Bool)
}

class MoviesViewController: UIViewController, MoviesViewControllerDelegate {
    private lazy var presenter = MoviesPresenter(moviesViewControllerDelegate: self)
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let searchTextField = UITextField()
    private let refreshControl = UIRefreshControl()
    private var activityView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupViews()
        setupLayout()
        presenter.handleViewDidLoad()
    }
    
    //MARK: - MoviesViewControllerDelegate
    
    func presentController(_ controller: UIViewController) {
        present(controller, animated: true)
    }
    
    func reloadTableView() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func pushController(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func setLoading(_ isPresented: Bool) {
        isPresented ? activityView.startAnimating() : activityView.stopAnimating()
        tableView.isHidden = isPresented
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
        view.addSubview(activityView)
        activityView.edgesToSuperview()
    }
    
    private func setupViews() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : AppColors.appColor
        ]
        navigationBarAppearance.backgroundColor = AppColors.appBlack
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        
        title = AppStrings.kinopoiskTitle
        view.backgroundColor = AppColors.appBlack
        
        let rightButton = UIBarButtonItem(image: AppImage.exit.systemImage(),
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightBarButtonHandler))
        rightButton.tintColor = AppColors.appColor
        navigationItem.setRightBarButton(rightButton, animated: false)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = AppColors.appWhite
        navigationItem.backBarButtonItem = backButton
        
        setupSearchTextField()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "\(MovieTableViewCell.self)")
        tableView.backgroundColor = AppColors.appBlack
        tableView.tableHeaderView = getTableHeader()
        
        refreshControl.tintColor = AppColors.appColor
        refreshControl.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHandler))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
        
        activityView.color = AppColors.appColor
    }
        
    private func getTableHeader() -> UIView {
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.alignment = .fill
        
        let sortButton = UIButton()
        sortButton.setImage(AppImage.sort.systemImage(), for: .normal)
        sortButton.tintColor = AppColors.appColor
        sortButton.addTarget(self, action: #selector(sortButtonHandler), for: .touchUpInside)
        
        [sortButton, searchTextField].forEach { subview in
            mainStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        
        sortButton.width(40)
        sortButton.leftToSuperview()
        searchTextField.rightToSuperview()
        mainStack.height(50)
        let wrapper = UIView()
        wrapper.addSubview(mainStack)
        mainStack.horizontalToSuperview(insets: .horizontal(16))
        mainStack.centerYToSuperview()
        wrapper.width(view.frame.width)
        wrapper.height(100)
        return wrapper
    }
    
    private func setupSearchTextField() {
        searchTextField.layer.borderWidth = 2
        searchTextField.layer.borderColor = AppColors.appGray.cgColor
        
        let leftPaddingView = UIView()
        leftPaddingView.width(16)
        searchTextField.leftView = leftPaddingView
        searchTextField.leftViewMode = .always
        searchTextField.textColor = AppColors.appWhite
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: AppStrings.searchPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.appGray]
        )
        
        let searchImageView = UIImageView(image: AppImage.search.systemImage())
        searchImageView.tintColor = AppColors.appColor
        
        let imageWrapper = UIView()
        imageWrapper.addSubview(searchImageView)
        searchImageView.edgesToSuperview(insets: .right(16))
        
        searchTextField.rightView = imageWrapper
        searchTextField.rightViewMode = .always
        searchTextField.textColor = AppColors.appWhite
        searchTextField.addTarget(self, action: #selector(textFieldDidChangeValueHandler), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(touchHandler), for: .editingDidEndOnExit)
    }
    
    // MARK: - handlers
    
    @objc
    private func rightBarButtonHandler() {
        presenter.exitButtonTapped()
    }
    
    @objc
    private func sortButtonHandler() {
        let filterController = MovieFilterViewController() { [weak self] filter in
            self?.presenter.handleDoFilter(filter: filter)
        }
        pushController(filterController)
    }
    
    @objc
    private func textFieldDidChangeValueHandler(textField: UITextField) {
        guard let searchText = textField.text else { return }
        presenter.handleFilterBySearch(searchText)
    }
    
    @objc
    private func refreshHandler() {
        presenter.handleRefresh()
    }
    
    @objc
    private func touchHandler() {
        view.endEditing(true)
    }
    
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.filteredMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieTableViewCell.self)") as? MovieTableViewCell
        cell?.setData(presenter.filteredMovieList[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.handleMovieTapWith(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.handleWillDisplayTableViewCell(with: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard presenter.isNeedDisplayLoadingFooterView else {
            return nil
        }
        
        let loaderView = UIActivityIndicatorView()
        loaderView.color = AppColors.appColor
        loaderView.startAnimating()
        let wrapper = UIView()
        wrapper.addSubview(loaderView)
        loaderView.edgesToSuperview()
        return wrapper
    }
    
}
