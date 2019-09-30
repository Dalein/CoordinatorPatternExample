//
//  BuyCoordinator.swift
//  Photos
//
//  Created by daleijn on 18/09/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit


class BuyCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let photo: Photo
    
    var didFinish: ((Coordinator) -> Void)?
    private let initialViewController: UIViewController?
    
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, photo: Photo) {
        self.navigationController = navigationController
        self.photo = photo
        
        self.initialViewController = navigationController.viewControllers.last
    }
    
    
    // MARK: - API
    
    func start() {
        guard UserDefaults.isSignedIn else {
            return self.showSignIn()
        }
        self.buyPhoto(photo)
    }
    
    
   
    
    private func finish() {
        // Reset Navigation Controller
        if let viewController = initialViewController {
            navigationController.popToViewController(viewController, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
            didFinish?(self)
        }
    }
    
    // MARK: - Deinitialization
    deinit {
        print("\(type(of: self)) deinit")
    }
    
}

// MARK: VCs flow
extension BuyCoordinator {
    
    private func showSignIn() {
           let signInViewController = SignInViewController.instantiate()
           let photo = self.photo
           
           signInViewController.didSignIn = { [weak self] (token) in
               UserDefaults.token = token
               self?.buyPhoto(photo)
           }
           
           signInViewController.didCancel = { [weak self] in
               self?.finish()
           }
           
          navigationController.pushViewController(signInViewController, animated: true)
       }
       
       private func buyPhoto(_ photo: Photo) {
           let buyViewController = BuyViewController.instantiate()
           buyViewController.photo = photo
           
           buyViewController.didCancel = { [weak self] in
               self?.finish()
           }
           
           buyViewController.didBuyPhoto = { [weak self] _ in
               UserDefaults.buy(photo: photo)
               self?.finish()
           }
           
           navigationController.pushViewController(buyViewController, animated: true)
       }
}


// MARK: UINavigationControllerDelegate methods
extension BuyCoordinator {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("navigationController didShow: \(viewController)")
        if viewController === initialViewController {
            didFinish?(self)
        }
    }
    
}
