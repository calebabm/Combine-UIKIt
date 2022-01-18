//
//  MainViewModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation

class MainViewModel {
    var results = Results(results: [])
    var pokemon: [Pokemon] = []
    var networkService: NetworkService
    
    func fetchData() {
        networkService.getRequest(urlString: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0", model: results) { result in
            switch result {
            case .success(let response):
                guard let pokemonResults = response as? Results else {
                    fatalError("No results from endpoint")
                }
                self.pokemon = pokemonResults.results
            case .failure(let error):
                print(error)
            }
        }
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        fetchData()
    }
}
