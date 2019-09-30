//
//  AppCoordinator.swift
//  Photos
//
//  Created by Bart Jacobs on 14/06/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit
import Foundation

class AppCoordinator: NSObject {
    private let navigationController = UINavigationController()
    private var childCoordinators = [Coordinator]()
    
    
    // MARK: - Public API
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    
    // MARK: -
    
    func start() {
        navigationController.delegate = self
        showPhotos()
    }

}

extension AppCoordinator: UINavigationControllerDelegate {
    
   func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        childCoordinators.forEach { childCoordinator in
            childCoordinator.navigationController(navigationController, willShow: viewController, animated: animated)
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
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
           
           navigationController.pushViewController(photosViewController, animated: true)
       }
    
    private func showPhoto(_ photo: Photo) {
           let photoViewController = PhotoViewController.instantiate()
           photoViewController.photo = photo

           photoViewController.didBuyPhoto = { [weak self] (photo) in
               self?.buyPhoto(photo)
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
       
       
       private func buyPhoto(_ photo: Photo) {
           let buyCoordinator = BuyCoordinator(navigationController: navigationController, photo: photo)
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
