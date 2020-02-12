//
//  PhotosTests.swift
//  PhotosTests
//
//  Created by ivan.gnatyuk on 12/02/2020.
//  Copyright © 2020 Code Foundry. All rights reserved.
//

import XCTest
@testable import Photos

class StoryboardableTests: XCTestCase {
    
    // MARK: - Test instantiations
    
    func testPhotosVC() {
        _ = PhotoViewController.instantiate()
    }
    
    func testPhotoVC() {
        _ = PhotoViewController.instantiate()
    }
    
    func testBuyVC() {
        _ = BuyViewController.instantiate()
    }
    
    func testSigninVC() {
        _ = SignInViewController.instantiate()
    }
    
}
