//
//  DetailViewModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import UIKit
import Combine

class DetailViewModel {
    
    @Published var name = ""
    @Published var weight = ""
    @Published var height = ""
    @Published var id = ""
    @Published var nickname = ""
    @Published var image = UIImage()
    
    private(set) var pokemonEntry: PokemonEntry
    
    func configureOutput() {
        name = "\(pokemonEntry.pokemonDetails.name)"
        weight = "\(pokemonEntry.pokemonDetails.weight)"
        height = "\(pokemonEntry.pokemonDetails.height)"
        id = "\(pokemonEntry.pokemonDetails.id)"
        nickname = ""
        image = pokemonEntry.image
    }
    
    init(_ pokemonEntry: PokemonEntry) {
        self.pokemonEntry = pokemonEntry
        configureOutput()
    }
}
