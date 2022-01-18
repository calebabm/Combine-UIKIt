//
//  DetailViewController.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    private(set) var viewModel: DetailViewModel!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = viewModel.pokemonEntry.image
        nameLabel.text = viewModel.pokemonEntry.pokemonDetails.name.capitalized
        weightLabel.text = "Weight: \(viewModel.pokemonEntry.pokemonDetails.weight)"
        heightLabel.text = "Height: \(viewModel.pokemonEntry.pokemonDetails.height)"
        idLabel.text = "ID: \(viewModel.pokemonEntry.pokemonDetails.id)"
    }
    
    func setup(_ viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
}
