//
//  UINavigationController+NavUtilits.swift
//  Photos
//
//  Created by daleijn on 17/09/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /// Pop to vc of type `vcType` or rootViewController if no such vc was in **viewControllers** array.
    func pop<V: AnyObject>(to vcType: V.Type) {
        if let viewController = self.viewControllers.first(where: { $0 is V }) {
            self.popToViewController(viewController, animated: true)
        } else {
            self.popToRootViewController(animated: true)
        }
    }
}
