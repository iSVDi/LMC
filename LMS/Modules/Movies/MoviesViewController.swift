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

//TODO: remove generated file from github
class MoviesViewController: UIViewController, MoviesViewControllerDelegate {
    private lazy var presenter = MoviesPresenter(moviesViewControllerDelegate: self)
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    private let searchTextField = UITextField()
    private let yearPicker = UIPickerView()
    private let refreshControl = UIRefreshControl()
    private lazy var stepperView: MovieStepperView = MovieStepperView { [weak self] in
        self?.presenter.stepBack()
    } forwardHander: { [weak self] in
        self?.presenter.stepForward()
    }

    private var activityView = UIActivityIndicatorView()
    
    private let stepperHeight: CGFloat = 50
    
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
        stepperView.setPage(presenter.currentPage)
        refreshControl.endRefreshing()
    }
    
    func pushController(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func setLoading(_ isPresented: Bool) {
        isPresented ? activityView.startAnimating() : activityView.stopAnimating()
        tableView.isHidden = isPresented
        stepperView.isHidden = isPresented
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        
        view.addSubview(tableView)
        view.addSubview(stepperView)
        tableView.edgesToSuperview(insets: .bottom(stepperHeight), usingSafeArea: true)
        stepperView.edgesToSuperview(excluding: .top, usingSafeArea: true)
        stepperView.topToBottom(of: tableView)
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
        yearPicker.dataSource = self
        yearPicker.delegate = self
        yearPicker.selectRow(presenter.selectedYearId, inComponent: 0, animated: false)
        yearPicker.tintColor = AppColors.appColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "\(MovieTableViewCell.self)")
        tableView.backgroundColor = AppColors.appBlack
        tableView.tableHeaderView = getSortingView()
        
        refreshControl.tintColor = AppColors.appColor
        refreshControl.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHandler))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
        
        activityView.color = AppColors.appColor
    }
    
    private func getSortingView() -> UIView {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.alignment = .center
        mainStack.spacing = 10

        let sortButtonSearchFieldStack = UIStackView()
        sortButtonSearchFieldStack.axis = .horizontal
        sortButtonSearchFieldStack.alignment = .fill
        
        let sortButton = UIButton()
        sortButton.setImage(AppImage.sort.systemImage(), for: .normal)
        sortButton.tintColor = AppColors.appColor
        sortButton.addTarget(self, action: #selector(sortButtonHandler), for: .touchUpInside)
        
        [sortButton, searchTextField].forEach { subview in
            sortButtonSearchFieldStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        sortButton.width(50)
        
        sortButtonSearchFieldStack.height(50)
        sortButton.leftToSuperview()
        searchTextField.rightToSuperview()
        
        [sortButtonSearchFieldStack, yearPicker].forEach { subview in
            mainStack.addArrangedSubview(subview)
        }
        
        sortButtonSearchFieldStack.horizontalToSuperview()
        
        let wrapper = UIView()
        wrapper.addSubview(mainStack)
        mainStack.edgesToSuperview(insets: .horizontal(16))
        wrapper.width(view.frame.width)
        wrapper.height(150)
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
        presenter.handleSortByRating()
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
    
}
// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension MoviesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.handleSelectYearFilter(row)
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(presenter.years[row])",
                                  attributes: [NSAttributedString.Key.foregroundColor: AppColors.appWhite])
    }
    
    
    
}
