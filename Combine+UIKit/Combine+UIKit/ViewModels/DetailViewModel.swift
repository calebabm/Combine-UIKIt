//
//  DetailViewModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation
import UIKit

class DetailViewModel {
    private(set) var pokemonEntry: PokemonEntry
    
    init(_ pokemonEntry: PokemonEntry) {
        self.pokemonEntry = pokemonEntry
    }
}
