//
//  ViewController.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    private(set) var viewModel: MainViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Pokemon"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setup(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.pokemon[indexPath.row].name.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(index: indexPath.row) { [weak self] viewController in
            DispatchQueue.main.async {
                self?.navigationController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
