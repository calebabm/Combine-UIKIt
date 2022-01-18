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
    }
}

enum NetworkError: Error {
    case errorDecoding
    case errorSerialization
}


