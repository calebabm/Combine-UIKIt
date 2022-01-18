//
//  DetailViewModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation
import UIKit

class DetailViewModel {
    var pokemon: Pokemon
    var pokemonDetails: PokemonDetails = PokemonDetails(height: 1, id: 1, name: "", sprites: Sprites(front_default: ""), weight: 1)
    lazy var pokemonEntry: PokemonEntry = PokemonEntry(pokemonDetails: pokemonDetails, image: UIImage())
    var networkService: NetworkService
    
    func fetchData(completion: @escaping () -> Void) {
        networkService.getRequest(urlString: pokemon.url, model: pokemonDetails) { result in
            switch result {
            case .success(let response):
                print("\(response)")
                guard let pokemonDetails = response as? PokemonDetails else {
                    fatalError("No results from endpoint")
                }
                self.pokemonDetails = pokemonDetails
                self.getSprite(completion: { image in
                    self.pokemonEntry = PokemonEntry(pokemonDetails: pokemonDetails, image: image)
                    completion()
                })
            case .failure(_):
                print("failure")
            }
        }
    }
    
    func getSprite(completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: pokemonDetails.sprites.front_default), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            fatalError("no valid data")
        }
        completion(image)
    }
    
    init(_ pokemon: Pokemon, _ networkService: NetworkService, completion: @escaping () -> Void) {
        self.pokemon = pokemon
        self.networkService = networkService
        fetchData(completion: {
            completion()
        })
    }
    
}
