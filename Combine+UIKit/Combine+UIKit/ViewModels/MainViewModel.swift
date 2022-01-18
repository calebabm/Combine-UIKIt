//
//  MainViewModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import UIKit

class MainViewModel {
    private(set) var networkService: NetworkService
    private(set) var results = Results(results: [])
    private(set) var pokemon: [Pokemon] = []
    
    //MARK: View actions
    func didSelectRow(index: Int, completion: @escaping (UIViewController) -> Void) {
        fetchPokemonDetails(pokemon: pokemon[index], completion: { pokemonEntry in
            let detailViewModel =  DetailViewModel(pokemonEntry)
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
                detailViewController.setup(detailViewModel)
                completion(detailViewController)
            }
        })
    }
    
    //MARK: Networking
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
    
    private func fetchPokemonDetails(pokemon: Pokemon, completion: @escaping (PokemonEntry) -> Void) {
        let placeHolderDetails = PokemonDetails(height: 0, id: 0, name: "", sprites: Sprites(front_default: ""), weight: 0)
        networkService.getRequest(urlString: pokemon.url, model: placeHolderDetails) { [weak self] result in
            switch result {
            case .success(let response):
                print("\(response)")
                guard let pokemonDetails = response as? PokemonDetails else {
                    fatalError("No results from endpoint")
                }
                self?.getSprite(pokemonDetails: pokemonDetails, completion: { image in
                    completion(PokemonEntry(pokemonDetails: pokemonDetails, image: image))
                })
            case .failure(_):
                fatalError("Unable to get data for \(pokemon.name)")
            }
        }
    }
    
    private func getSprite(pokemonDetails: PokemonDetails, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: pokemonDetails.sprites.front_default), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            fatalError("no valid data")
        }
        completion(image)
    }
    
    init(networkService: NetworkService, completion: @escaping () -> Void) {
        self.networkService = networkService
        fetchData(completion: {
            completion()
        })
    }
}
