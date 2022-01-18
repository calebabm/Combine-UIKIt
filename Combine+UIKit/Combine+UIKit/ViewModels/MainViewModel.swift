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
    
    func attachViewEventListener(loadData: AnyPublisher<Void, Never>) {
        self.loadData = loadData
        self.loadData
//            .setFailureType(to: Error.self)
//            .handleEvents(receiveOutput: { [weak self] _ in
//                self?.pokemon.removeAll()
//            })
            .flatMap { _ -> AnyPublisher<Results, Error> in
                return self.fetchData()
            }
        .receive(on: DispatchQueue.main)
            .handleEvents(receiveRequest:  { [weak self] _ in
                self?.pokemon.removeAll()
            }).sink(receiveCompletion: { _ in }) { [weak self] pokemonResult in
                self?.pokemon = pokemonResult.results
                self?.reloadPokemonSubject.send(.success(()))
            }.store(in: &subscriptions)
        
    }
    
    //MARK: Networking
    private func fetchData() -> AnyPublisher<Results, Error> {
        return networkService.getRequest(urlString: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0", model: results)
    }
    
    private func fetchPokemonDetails(pokemon: Pokemon, completion: @escaping (PokemonEntry) -> Void) {
//        let placeHolderDetails = PokemonDetails(height: 0, id: 0, name: "", sprites: Sprites(front_default: ""), weight: 0)
//        let asdf = networkService.getRequest(urlString: pokemon.url, model: placeHolderDetails)
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
