//
//  PokemonModel.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation

struct Results : Codable {
    let results : [Pokemon]
}

struct Pokemon: Codable {
    var name: String
    var url: String
}

class PokemonDetails: Codable {
    
    var height: Int
    var id: Int
    var name: String
    var sprites: Sprites
    var weight: Int
    
    init(height: Int, id: Int, name: String, sprites: Sprites, weight: Int) {
        self.height = height
        self.id = id
        self.name = name
        self.sprites = sprites
        self.weight = weight
    }
}

struct Sprites: Codable {

    var front_default: String
    
    internal init(front_default: String) {
        self.front_default = front_default
    }
}
