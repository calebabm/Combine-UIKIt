//
//  MainViewModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import UIKit
import Combine

class MainViewModel {
    
    private var loadData: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    var reloadPokemonSubject = PassthroughSubject<Result<Void, Error>, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    var selectedPokemonSubject = PassthroughSubject<PokemonEntry, Never>()
    var selectedPokemon: AnyPublisher<PokemonEntry, Never> {
            selectedPokemonSubject.eraseToAnyPublisher()
    }
    
    private(set) var networkService: NetworkService
    private(set) var results = Results(results: [])
    private(set) var pokemon: [Pokemon] = []
    
    //MARK: View actions
    func didSelectRow(for pokemon: Pokemon) {
        self.fetchPokemonDetails(pokemon: pokemon)
//        let pokemonDetails = fetchPokemonDetails(pokemon: pokemon[index])
//        let _ = pokemonDetails.sink(receiveCompletion: { _ in }) { pokemonDetails in
//            self.getSprite(pokemonDetails: pokemonDetails) { sprite in
//                let entry = PokemonEntry(pokemonDetails: pokemonDetails, image: sprite)
//                let detailViewModel =  DetailViewModel(entry)
//                DispatchQueue.main.async {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    guard let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
//                    detailViewController.setup(detailViewModel)
//                    completion(detailViewController)
//                }
//            }
//        }
    }
    
    //MARK: Attach reloadPokemonSubject to changes from network request
    func attachViewEventListener(loadData: AnyPublisher<Void, Never>) {
        self.loadData = loadData
        self.loadData
            .flatMap { _ -> AnyPublisher<Results, Error> in
                return self.fetchData()
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveRequest:  { [weak self] _ in
                self?.pokemon.removeAll()
            })
            .sink(receiveCompletion: { _ in }) { [weak self] pokemonResult in
                self?.pokemon = pokemonResult.results
                self?.reloadPokemonSubject.send(.success(()))
            }
            .store(in: &subscriptions)
    }
    
    //MARK: Networking
    private func fetchData() -> AnyPublisher<Results, Error> {
        return networkService.getRequest(urlString: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0", model: results)
    }
    
    private func fetchPokemonDetails(pokemon: Pokemon) {
        let placeHolderDetails = PokemonDetails(height: 0, id: 0, name: "", sprites: Sprites(front_default: ""), weight: 0)
        networkService.getRequest(urlString: pokemon.url, model: placeHolderDetails).sink { error in
            print(error)
        } receiveValue: { details in
            self.getSprite(pokemonDetails: details) { sprite in
                let entry = PokemonEntry(pokemonDetails: details, image: sprite)
                self.selectedPokemonSubject.send(entry)
            }
        }.store(in: &subscriptions)
    }
    
    private func getSprite(pokemonDetails: PokemonDetails, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: pokemonDetails.sprites.front_default), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            fatalError("no valid data")
        }
        completion(image)
    }
    
    init(networkService: NetworkService, completion: @escaping () -> Void) {
        self.networkService = networkService
        completion()
    }
}
