//
//  Coordinator.swift
//  Photos
//
//  Created by daleijn on 18/09/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate {
    var didFinish: ((Coordinator) -> ())?
    
    func start() {}
    
    // MARK: - For notifying child  coordinators
    // MARK: - Default implementation for this methods. If child coordinators don't need them - they don't have to impl them.
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {}
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {}
}
