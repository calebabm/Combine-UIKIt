//
//  MainViewModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import UIKit
import Combine

class MainViewModel {
    
    private(set) var subscriptions = Set<AnyCancellable>()
    
    //MARK: Table View Datasource
    private var loadData: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    var reloadPokemonSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    //MARK: Detail View Datasource
    var selectedPokemonSubject = PassthroughSubject<PokemonEntry, Never>()
    var selectedPokemon: AnyPublisher<PokemonEntry, Never> {
        selectedPokemonSubject.eraseToAnyPublisher()
    }
    
    private(set) var networkService: NetworkService
    private(set) var results = Results(results: [])
    private(set) var pokemon: [Pokemon] = []
    
    
    //MARK: View actions
    func didSelectRow(_ index: Int) {
        self.attachSelectedPokemonEventListener(pokemon: self.pokemon[index])
    }
    
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
    
    private func attachSelectedPokemonEventListener(pokemon: Pokemon) {
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
    
    private func fetchData() -> AnyPublisher<Results, Error> {
        return networkService.getRequest(urlString: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0", model: results)
    }
    
    private func getSprite(pokemonDetails: PokemonDetails, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: pokemonDetails.sprites.front_default), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            fatalError("no valid data")
        }
        completion(image)
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
