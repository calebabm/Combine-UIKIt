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
        self.imageView.image = viewModel.pokemonEntry.image
//        self.nameLabel.text = viewModel.pokemonEntry.pokemonDetails.name
//        self.weightLabel.text = "\(viewModel.pokemonEntry.pokemonDetails.weight)"
//        self.heightLabel.text = "\(viewModel.pokemonEntry.pokemonDetails.height)"
//        self.idLabel.text = "\(viewModel.pokemonEntry.pokemonDetails.id)"
    }
    
    func setup(_ viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
}
