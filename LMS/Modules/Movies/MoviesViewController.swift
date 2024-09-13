//
//  MoviesViewController.swift
//  LMS
//
//  Created by Daniil on 11.09.2024.
//

import Foundation
import UIKit

protocol MoviesViewControllerDelegate: AnyObject {
    func exitWith(_ controller: UINavigationController)
    func reloadTableView()
    func presentController(_ controller: UIViewController)
}

class MoviesViewController: UIViewController, MoviesViewControllerDelegate {
    private lazy var presenter = MoviesPresenter(moviesViewControllerDelegate: self)
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupViews()
        setupLayout()
        presenter.handleViewDidLoad()
    }
    
    //MARK: - MoviesViewControllerDelegate
    
    func exitWith(_ controller: UINavigationController) {
        present(controller, animated: true)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func presentController(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
    }
    
    private func setupViews() {
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:AppColors.appColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "KinoPoisk" //TODO: localize
        view.backgroundColor = AppColors.appBlack
        
        
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightBarButtonHandler))
        navigationItem.setRightBarButton(rightButton, animated: false)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = AppColors.appWhite
        navigationItem.backBarButtonItem = backButton
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "\(MovieTableViewCell.self)")
        tableView.backgroundColor = AppColors.appBlack
    }
    
    // MARK: - handlers
    
    @objc
    private func rightBarButtonHandler() {
        presenter.exitButtonTapped()
    }
}

//MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.movieList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieTableViewCell.self)") as? MovieTableViewCell
        cell?.setData(presenter.movieList.items[indexPath.row])
       
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
