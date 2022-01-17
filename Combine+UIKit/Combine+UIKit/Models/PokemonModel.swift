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

struct PokemonDetails: Codable {
//    var abilities: [String]
    var base_experience: Int
//    var forms: [String]
//    var game_indices: [String]
    var height: Int
//    var held_items: [String]
    var id: Int
    var is_default: Bool
    var location_area_encounters: String
//    var moves: [String]
    var name: String
    var order: Int
//    var past_types: [String]
//    var species: [String]
//    var sprites: Sprite
//    var stats: [String]
//    var types: [String]
    var weight: Int
    
}
