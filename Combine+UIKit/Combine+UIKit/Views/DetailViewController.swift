//
//  DetailViewController.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private(set) var viewModel: DetailViewModel!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        nameLabel.text = nameLabel.text?.capitalized
    }
    
    func setupBindings() {
        subscriptions = [
            viewModel.$image.assign(to: \.image!, on: imageView),
            viewModel.$name.assign(to: \.text!, on: nameLabel),
            viewModel.$weight.assign(to: \.text!, on: weightLabel),
            viewModel.$height.assign(to: \.text!, on: heightLabel),
            viewModel.$id.assign(to: \.text!, on: idLabel)
        ]
    }
    
    func setup(_ viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
}
