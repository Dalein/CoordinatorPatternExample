//
//  TermsViewControllerCode.swift
//  Photos
//
//  Created by daleijn on 13/10/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class TermsViewControllerCode: TermsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .darkGray

        let button = UIButton(frame: .init(origin: .zero, size: .init(width: 100, height: 50)))
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        button.center = self.view.center
        self.view.addSubview(button)
    }
    

}
