//
//  SceneDelegate.swift
//  Combine+UIKit
//
//  Created by Caleb Meurer on 1/17/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        configureInitialView(with: windowScene)
    }
    
    private func configureInitialView(with windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
        let viewModel = MainViewModel(networkService: NetworkService()) { [weak self] in
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: mainViewController)
                self?.window?.rootViewController = navigationController
                self?.window?.makeKeyAndVisible()
            }
        }
        mainViewController.setup(viewModel)
    }
}


