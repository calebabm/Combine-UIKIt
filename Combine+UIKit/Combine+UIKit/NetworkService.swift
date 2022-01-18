//
//  NetworkService.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation

class NetworkService {
    func getRequest<T: Codable>(urlString: String, model: T, completion: @escaping (Result<Codable, Error>) -> Void) {
        //create url
        guard let url = URL(string: urlString) else { return }
        //create session
        let session = URLSession(configuration: .default)
        //create data task
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                fatalError("No data from request")
            }
            self.parseResultsJson(data: data, modelType: model) { result in
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        //start tast
        dataTask.resume()
    }
    
    func parseResultsJson<T: Codable>(data: Data, modelType: T, completion: (Result<T, Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        guard let decodedData = try? jsonDecoder.decode(T.self, from: data) else {
            fatalError("Error decoding data from json to type")
        }
        completion(.success(decodedData))
        
    }
}


