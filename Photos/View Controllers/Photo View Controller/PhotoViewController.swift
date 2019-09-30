//
//  PhotoViewController.swift
//  Photos
//
//  Created by Bart Jacobs on 14/06/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, Storyboardable {

    // MARK: - Properties
    
    @IBOutlet var imageView: UIImageView! {
        didSet {
            // Configure Image View
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: -
    
    @IBOutlet var purchasedView: UIView! {
        didSet {
            // Configure Layer Purchased View
            purchasedView.layer.cornerRadius = 8.0
            purchasedView.layer.masksToBounds = true
        }
    }
    
    // MARK: -
    
    var photo: Photo?
    
    // MARK: -
    
    var didBuyPhoto: ((Photo) -> Void)?
    
    // MARK: -
    
    private var dataTask: URLSessionDataTask?

    // MARK: - Deinitialization

    deinit {
        // Cancel Data Task
        dataTask?.cancel()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View
        setupView()
        
        // Set Title
        title = photo?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update View
        updateView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        // Setup Image View
        setupImageView()
        
        // Update View
        updateView()
    }
    
    private func updateView() {
        guard let photo = photo else {
            return
        }
        
        if UserDefaults.didBuy(photo) {
            // Show Purchased View
            purchasedView.isHidden = false
            
            // Remove Bar Button Item
            navigationItem.rightBarButtonItem = nil
        } else {
            // Show Purchased View
            purchasedView.isHidden = true
            
            // Add Bar Button Item
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Buy", style: .plain, target: self, action: #selector(buy(_:)))
        }
    }
    
    // MARK: -
    
    private func setupImageView() {
        guard let url = photo?.url else {
            return
        }
        
        // Create and Resume Data Task
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data else {
                return
            }
            
            // Create Image
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                // Update Thumbnail Image View
                self?.imageView.image = image
            }
        }
        
        // Resume Data Task
        dataTask?.resume()
    }
    
    // MARK: - Actions
    
    @objc func buy(_ sender: UIBarButtonItem) {
        guard let photo = photo else {
            return
        }
        
        // Invoke Handler
        didBuyPhoto?(photo)
    }

}
