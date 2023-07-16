//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by emirhan Acısu on 16.07.2023.
//

import Foundation

enum EventType {
    case newSearch
    case pagination
    case first
}

class HomeViewModel {
    
    var tableViewMovieModel: [Movie] = []
    var collectionViewMovieModel: [Movie] = []
    
    var lastSearchText = "Star"
    let comedySearchText = "Comedy"
    
    var currentPage: Int = 1
    var collectionCurrentPage: Int = 1
    var totalResult: Int?
    var collectionTotalResult: Int?
    
    var reloadDataClosure: ReloadDataClosure?
    var showIndicator: BoolClosure?
    var failClosure: StringClosure?
    
    var eventType: EventType = .first
    
    func numberOfRowsInSection() -> Int {
        tableViewMovieModel.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Movie? {
        tableViewMovieModel[indexPath.row]
    }
    
    func numberOfItemsInSection() -> Int {
        collectionViewMovieModel.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> Movie? {
        collectionViewMovieModel[indexPath.row]
    }
    
    func getMoviesGroup() {
        
        let group = DispatchGroup()
        
        group.enter()
        getMovies(searchText: lastSearchText, isForCollectionData: false) {
            group.leave()
        }
        
        group.enter()
        getMovies(searchText: comedySearchText, isForCollectionData: true) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.reloadDataClosure?(.all)
        }
    }
    
    func checkPagination(indexPath: IndexPath) {
        if (indexPath.row == numberOfRowsInSection() - 2) && totalResult ?? 0 > numberOfRowsInSection() {
            currentPage += 1
            eventType = .pagination
            getMovies(searchText: lastSearchText, page: String(currentPage))
        }
    }
    
    func checkCollectionPagination(indexPath: IndexPath) {
        if (indexPath.row == numberOfItemsInSection() - 2) && collectionTotalResult ?? 0 > numberOfItemsInSection() {
            collectionCurrentPage += 1
            eventType = .pagination
            getMovies(searchText: comedySearchText, isForCollectionData: true, page: String(collectionCurrentPage))
        }
    }
    
    func configureNewSearch(result: MovieResponse) {
        self.tableViewMovieModel = result.search
        self.totalResult = Int(result.totalResults)
        self.reloadDataClosure?(.tableView)
    }
    
    func configurePagination(result: MovieResponse, isForCollection: Bool) {
        if isForCollection {
            self.collectionViewMovieModel += result.search
            self.reloadDataClosure?(.collectionView)
        } else {
            self.tableViewMovieModel += result.search
            self.reloadDataClosure?(.tableView)
        }
    }
    
    func configureFirst(result: MovieResponse, isForCollection: Bool, completion: (() -> ())?) {
        if isForCollection {
            self.collectionViewMovieModel = result.search
            self.collectionTotalResult = Int(result.totalResults)
        } else {
            self.tableViewMovieModel = result.search
            self.totalResult = Int(result.totalResults)
        }
        completion?()
    }
    
    func searchMovies(searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else {
            return lastSearchText = ""
        }
        lastSearchText = searchText
        currentPage = 1
        eventType = .newSearch
        getMovies(searchText: searchText)
    }
    
    func getMovies(searchText: String, isForCollectionData: Bool = false, page: String = "1", completion: (() -> ())? = nil) {
        guard let request = SearchRequest(searchText: searchText, page: page).request() else { return }
        guard !lastSearchText.isEmpty else { return }
        showIndicator?(true)
        Network().performRequest(request: request) { [weak self] (response: Result<MovieResponse, Error>) in
            guard let self = self else { return  }
            showIndicator?(false)
            switch response {
            case .success(let result):
                switch self.eventType {
                case .first:
                    self.configureFirst(result: result, isForCollection: isForCollectionData, completion: {
                        completion?()
                    })
                case .newSearch:
                    self.configureNewSearch(result: result)
                case .pagination:
                    self.configurePagination(result: result, isForCollection: isForCollectionData)
                }
                
            case .failure(let error):
                showIndicator?(false)
                failClosure?(error.localizedDescription)
            }
        }
    }
}
