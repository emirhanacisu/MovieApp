//
//  Network.swift
//  MovieApp
//
//  Created by emirhan Acısu on 15.07.2023.
//

import Foundation

let baseURL = "https://www.omdbapi.com/"
let apiKey = "41d6c40d"

class Network {
    
    func performRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, Error>)->Void) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                guard let data = data else { return }
                let response = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
