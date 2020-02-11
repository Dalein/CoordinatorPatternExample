//
//  TermsViewController.swift
//  Photos
//
//  Created by daleijn on 13/10/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    var didCancel: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        didCancel?()
    }
    
}
