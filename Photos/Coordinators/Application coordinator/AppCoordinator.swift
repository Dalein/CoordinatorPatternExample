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
    
    
    // MARK: - Public API
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    
    // MARK: -
    
    override func start() {
        navigationController.delegate = self
        showPhotos()
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
