//
//  MainViewModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation

class MainViewModel {
    private(set) var networkService: NetworkService
    private(set) var results = Results(results: [])
    private(set) var pokemon: [Pokemon] = []
    
    private func fetchData(completion: @escaping () -> Void) {
        networkService.getRequest(urlString: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0", model: results) { [weak self] result in
            switch result {
            case .success(let response):
                guard let pokemonResults = response as? Results else {
                    fatalError("No results from endpoint")
                }
                self?.pokemon = pokemonResults.results
                completion()
            case .failure(let error):
                fatalError("No data from url: \(error)")
            }
        }
    }
    
    init(networkService: NetworkService, completion: @escaping () -> Void) {
        self.networkService = networkService
        fetchData(completion: {
            completion()
        })
    }
}
