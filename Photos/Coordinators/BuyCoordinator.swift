//
//  BuyCoordinator.swift
//  Photos
//
//  Created by daleijn on 18/09/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit


class BuyCoordinator: Coordinator {
    private let photo: Photo
    private let navigationController: UINavigationController
    
    /// Only required to manage the horizontal purchase flow.
    private var initialViewController: UIViewController?
    
    /**
     VC that will present coordinator's navigation controller (for vertical flow).
     We don't pass a navigation controller to the initializer.
     The coordinator is responsible for the creation and configuration of its navigation controller.
     */
    private var presentingViewController: UIViewController?
    
    
    // MARK: - Init
    
    /// Init as horizontal flow
    init(navigationController: UINavigationController, photo: Photo) {
        self.navigationController = navigationController
        self.photo = photo
        
        self.initialViewController = navigationController.viewControllers.last
        super.init()
    }
    
    /// Init as vertical flow
    init(presentingViewController: UIViewController, photo: Photo) {
        self.presentingViewController = presentingViewController
        self.photo = photo
        
        // Initialize Navigation Controller
        self.navigationController = UINavigationController()
        
        super.init()
        navigationController.delegate = self
    }
    
    
    // MARK: - API
    
    override func start() {
        if UserDefaults.isSignedIn {
            self.buyPhoto(photo)
        } else {
            self.showSignIn()
        }
        
        self.presentingViewController?
            .present(navigationController, animated: true) // execute only if it's not nil (if it's vertical flow)
    }
    
    
    private func finish() {
        // Reset Navigation Controller
        if let viewController = initialViewController {
            navigationController.popToViewController(viewController, animated: true)
        } else {
            presentingViewController?.dismiss(animated: true)
            didFinish?(self)
        }
    }
    
    
    // MARK: - UINavigation delegate
    
    override func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("navigationController didShow: \(viewController)")
        if viewController === initialViewController {
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
        
        buyViewController.didShowTerms = { [weak self] in
            self?.showTerms()
        }
        
        navigationController.pushViewController(buyViewController, animated: true)
    }
    
    private func showTerms() {
        let termsCoordinator = TermsCoordinator(presentingViewController: navigationController)
        pushCoordinator(termsCoordinator)
    }
}
