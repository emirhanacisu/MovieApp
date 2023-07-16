//
//  ViewController.swift
//  MovieApp
//
//  Created by emirhan Acısu on 15.07.2023.
//

import UIKit
import TinyConstraints

class HomeViewController: BaseViewController {
    
    var timer = Timer()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: "MoviesTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.height(160)
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
        collectionView.layer.borderWidth = 1
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        return collectionView
    }()
    
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getMoviesGroup()
        setupViews()
        showLoading()
        configureViews()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.reloadDataClosure = { [weak self] type in
            switch type {
            case .all:
                self?.tableView.reloadData()
                self?.collectionView.reloadData()
            case .collectionView:
                self?.collectionView.reloadData()
            case .tableView:
                self?.tableView.reloadData()
                if self?.viewModel.eventType == .newSearch {
                    self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
        
        viewModel.showIndicator = { isShow in
            isShow ? self.showLoading() : self.hideLoading()
        }
        
        viewModel.failClosure = { [weak self] errorMessage in
            self?.presentErrorAlert(errorMessage: errorMessage)
        }
    }
    
    private func setupViews() {
        setupSearchBar()
        setupTableView()
        setupCollectionView()
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.topToSuperview(usingSafeArea: true)
        searchBar.leadingToSuperview().constant = 16
        searchBar.trailingToSuperview().constant = -16
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.topToBottom(of: searchBar).constant = 16
        tableView.leadingToSuperview().constant = 16
        tableView.trailingToSuperview().constant = -16
        tableView.separatorStyle = .none
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.topToBottom(of: tableView).constant = 16
        collectionView.leadingToSuperview()
        collectionView.trailingToSuperview()
        collectionView.bottomToSuperview().constant = -40
    }
    
    private func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
    }
    
    @objc
    func timerAction() {
        viewModel.searchMovies(searchText: searchBar.text)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let item = viewModel.cellForRowAt(indexPath: indexPath)
        cell.set(viewModel: MoviesTableViewCellModel(title: item?.title, description: item?.year, poster: item?.poster))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.checkPagination(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.cellForRowAt(indexPath: indexPath)
        let viewController = MovieDetailViewController()
        viewController.viewModel = MovieDetailViewModel(imageUrl: item?.poster, title: item?.title, description: item?.year)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        let item = viewModel.cellForItemAt(indexPath: indexPath)
        cell.set(viewModel: MovieCollectionViewCellModel(poster: item?.poster))
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.checkCollectionPagination(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.cellForItemAt(indexPath: indexPath)
        let viewController = MovieDetailViewController()
        viewController.viewModel = MovieDetailViewModel(imageUrl: item?.poster, title: item?.title, description: item?.year)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }

}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
}
