//
//  BuyViewController.swift
//  Photos
//
//  Created by Bart Jacobs on 15/06/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController, Storyboardable {
    
    var photo: Photo?
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    
    // MARK: - Handlers
    var didCancel: (() -> Void)?
    var didBuyPhoto: ((Photo) -> Void)?
    var didShowTerms: (() -> Void)?
    

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View
        setupView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        configNavigationItem()
        
        setupTitleLabel()
        setupPriceLabel()
    }
    
    private func configNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.hidesBackButton = true
    }
    
    // MARK: -
    
    private func setupTitleLabel() {
        titleLabel.text = photo?.title
    }
    
    private func setupPriceLabel() {
        var formattedPrice: String?
        
        if let price = photo?.price {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale.current
            numberFormatter.numberStyle = .currency
       
            formattedPrice = numberFormatter.string(from: NSNumber(value: price))
        }
        
        if let text = formattedPrice {
            priceLabel.text = text

        } else {
            priceLabel.text = "-"

            buyButton.isEnabled = false
        }
    }
    
    // MARK: - Actions

    @IBAction func buy(_ sender: Any) {
        guard let photo = photo else {
            return
        }
        
        // Show Activity Indicator View
        activityIndicatorView.startAnimating()
        
        // Hide Buy Button
        buyButton.isHidden = true
        
        // Disable Cancel Button
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DispatchQueue.global().async {
            sleep(2)
            
            DispatchQueue.main.async {
                // Hide Activity Indicator View
                self.activityIndicatorView.stopAnimating()
                
                // Enable Cancel Button
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                // Invoke Handler
                self.didBuyPhoto?(photo)
            }
        }
    }

    @objc func cancel(_ sender: UIBarButtonItem) {
        didCancel?()
    }
    
    @IBAction func showTerms(_ sender: Any) {
        didShowTerms?()
    }

}
