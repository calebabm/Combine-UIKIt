//
//  ViewController.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    private(set) var subscriptions = Set<AnyCancellable>()
    private(set) var loadDataSubject = PassthroughSubject<Void, Never>()
    private(set) var selectedEntry: PokemonEntry?
    
    private(set) var viewModel: MainViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pokemon"
        tableView.delegate = self
        tableView.dataSource = self
        setupBinding()
        loadDataSubject.send()
        tableView.reloadData()
    }
    
    private func setupBinding() {
        viewModel.attachViewEventListener(loadData: loadDataSubject.eraseToAnyPublisher())
        
        viewModel.reloadPokemonSubject
            .sink { completion in
                print("There was an error")
            } receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        
        viewModel.selectedPokemon.sink { _ in } receiveValue: { entry in
            DispatchQueue.main.async {
                let viewModel = DetailViewModel(entry)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
                detailViewController.setup(viewModel)
                self.navigationController?.present(detailViewController, animated: true, completion: nil)
            }
        }
        .store(in: &subscriptions)

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
        viewModel.didSelectRow(indexPath.row)
    }
}
