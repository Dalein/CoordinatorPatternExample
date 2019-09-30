//
//  PhotoTableViewCell.swift
//  Photos
//
//  Created by Bart Jacobs on 14/06/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    // MARK: - Static Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Properties
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private var buyButton: UIButton! {
        didSet {
            // Configure Buy Button
            buyButton.setTitle("Buy", for: .normal)
            
            // Add Target/Action
            buyButton.addTarget(self, action: #selector(buy(_:)), for: .touchUpInside)
        }
    }
    
    var didBuy: (() -> Void)?

    
    // MARK: -
    
    private var dataTask: URLSessionDataTask?
    
    
    // MARK: - Public API
    
    func configure(title: String, url: URL?, didBuyPhoto: Bool) {
        // Configure Title Label
        titleLabel.text = title
        
        // Show/Hide Buy Button
        buyButton.isHidden = didBuyPhoto
        
        // Animate Activity Indicator View
        activityIndicatorView.startAnimating()
        
        guard let url = url else {
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
                self?.thumbnailImageView.image = image
            }
        }
        
        // Resume Data Task
        dataTask?.resume()
    }
    
    
    // MARK: - Actions
    
    @objc private func buy(_ sender: UIButton) {
        didBuy?()
    }
    
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Cancel Data Task
        dataTask?.cancel()
        
        // Reset Thumnail Image View
        thumbnailImageView.image = nil
    }

}
