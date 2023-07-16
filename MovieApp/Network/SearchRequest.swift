//
//  SearchRequest.swift
//  MovieApp
//
//  Created by emirhan Acısu on 17.07.2023.
//

import Foundation

class SearchRequest {
    var searchText: String
    var page: String = "1"
    
    
    init(searchText: String, page: String) {
        self.searchText = searchText
        self.page = page
    }
    
    func request() -> URLRequest? {
        let urlString = "\(baseURL)?s=\(self.searchText)&page=\(self.page)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
}
