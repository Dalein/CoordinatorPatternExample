//
//  TermsViewControllerXIB.swift
//  Photos
//
//  Created by daleijn on 13/10/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class TermsViewControllerXIB: TermsViewController {
    @IBOutlet weak var lblTermsOfService: UILabel! {
        didSet {
            lblTermsOfService.text = termsOfService
        }
    }
    
    static var nibName: String {
        return String(describing: self)
    }
    
    private let termsOfService: String
    
    
    // MARK: - Init
    
    init(termsOfService: String) {
        self.termsOfService = termsOfService
        super.init(nibName: TermsViewControllerXIB.nibName, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
