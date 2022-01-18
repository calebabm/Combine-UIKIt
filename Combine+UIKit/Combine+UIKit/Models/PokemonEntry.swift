//
//  PokemonEntry.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation
import UIKit

class PokemonEntry {
    var nickname = ""
    var pokemonDetails: PokemonDetails
    var image: UIImage
    
    init(pokemonDetails: PokemonDetails, image: UIImage) {
        self.pokemonDetails = pokemonDetails
        self.image = image
    }
}
