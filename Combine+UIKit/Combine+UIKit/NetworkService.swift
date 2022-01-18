//
//  NetworkService.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation
import Combine

class NetworkService {
    func getRequest<T: Codable>(urlString: String, model: T, parameter: [String: AnyObject]? = nil) -> AnyPublisher<T, Error>  {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid url")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        let dataTask = session.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                fatalError("No data from request")
//            }
//        guard let data = request.httpBody else {
//            fatalError("No data from server")
//        }
        
        if let requestBodyParams = parameter {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBodyParams, options: .prettyPrinted)
            } catch {
                return Fail(error: NetworkError.errorSerialization).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .catch { _ in Fail(error: NetworkError.errorDecoding).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
//            self.parseResultsJson(data: data, modelType: model) { result in
//                switch result {
//                case .success(let model):
//                    completion(.success(model))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//        dataTask.resume()
    }
    
    private func parseResultsJson<T: Codable>(data: Data, modelType: T, completion: (Result<T, Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        guard let decodedData = try? jsonDecoder.decode(T.self, from: data) else {
            fatalError("Error decoding data from json to type")
        }
        completion(.success(decodedData))
    }
}

enum NetworkError: Error {
    case errorDecoding
    case errorSerialization
}


