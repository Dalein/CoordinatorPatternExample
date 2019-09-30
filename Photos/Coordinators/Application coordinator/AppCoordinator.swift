//
//  AppCoordinator.swift
//  Photos
//
//  Created by Bart Jacobs on 14/06/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

private extension AppCoordinator {
    enum PurchaseFlowType {
        case horizontal
        case vertical
    }
}

class AppCoordinator: Coordinator {
    private let navigationController = UINavigationController()
    private var childCoordinators = [Coordinator]()
    
    
    // MARK: - Public API
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    
    // MARK: -
    
    override func start() {
        navigationController.delegate = self
        showPhotos()
    }
    
    
    // MARK: - UINavigationControllerDelegate
    
    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        childCoordinators.forEach { childCoordinator in
            childCoordinator.navigationController(navigationController, willShow: viewController, animated: animated)
        }
    }
    
    override func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        childCoordinators.forEach { childCoordinator in
            childCoordinator.navigationController(navigationController, didShow: viewController, animated: animated)
        }
    }
}


// Mark Flow methods
extension AppCoordinator {
    
    private func showPhotos() {
        let photosViewController = PhotosViewController.instantiate()
        
        photosViewController.didSelectPhoto = { [weak self] (photo) in
            self?.showPhoto(photo)
        }
        
        photosViewController.didSignIn = { [weak self] in
            self?.showSignIn()
        }
        
        photosViewController.didBuyPhoto = { [weak self] (photo) in
            self?.buyPhoto(photo, purchaseFlowType: .vertical)
        }

        
        navigationController.pushViewController(photosViewController, animated: true)
    }
    
    private func showPhoto(_ photo: Photo) {
        let photoViewController = PhotoViewController.instantiate()
        photoViewController.photo = photo
        
        photoViewController.didBuyPhoto = { [weak self] (photo) in
            self?.buyPhoto(photo, purchaseFlowType: .horizontal)
        }
        
        navigationController.pushViewController(photoViewController, animated: true)
    }
    
    
    private func showSignIn() {
        let signInViewController = SignInViewController.instantiate()
        
        signInViewController.didSignIn = { [weak self] (token) in
            UserDefaults.token = token
            self?.navigationController.dismiss(animated: true)
        }
        
        signInViewController.didCancel = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        
        navigationController.present(signInViewController, animated: true)
    }
    
    
    private func buyPhoto(_ photo: Photo, purchaseFlowType: PurchaseFlowType) {
        let buyCoordinator: BuyCoordinator
        
        switch purchaseFlowType {
        case .horizontal:
            buyCoordinator = BuyCoordinator(navigationController: navigationController, photo: photo)
        case .vertical:
            buyCoordinator = BuyCoordinator(presentingViewController: navigationController, photo: photo)
        }
        
        pushCoordinator(buyCoordinator)
    }
}


// MARK: - Helper Methods
extension AppCoordinator {
    
    private func pushCoordinator(_ coordinator: Coordinator) {
        coordinator.didFinish = { [weak self] coordinator in
            self?.popCoordinator(coordinator)
        }
        
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    private func popCoordinator(_ coordinator: Coordinator) {
        // Remove Coordinator From Child Coordinators
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
