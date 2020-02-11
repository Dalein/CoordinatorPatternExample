//
//  TermsCoordinator.swift
//  Photos
//
//  Created by daleijn on 13/10/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class TermsCoordinator: Coordinator {
    private let presentingViewController: UIViewController
    
    
    // MARK: - Init
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    
    // MARK: - API
    
    override func start() {
        showTerms()
    }
    
    
    private func showTerms() {
        // Storyboard
//        let termsViewController = TermsViewControllerStoryboard.instantiate()
        
        // Xib
        let termsViewController = TermsViewControllerXIB(termsOfService: "These are the terms of service.")
        
        // Code
//        let termsViewController = TermsViewControllerCode()

        termsViewController.didCancel = { [weak self] in
            self?.finish()
        }

        presentingViewController.present(termsViewController, animated: true)
    }
    
    private func finish() {
        presentingViewController.dismiss(animated: true)
        didFinish?(self)
    }
    
}
