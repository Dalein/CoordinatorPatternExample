//
//  PhotosViewController.swift
//  Photos
//
//  Created by Bart Jacobs on 14/06/2019.
//  Copyright © 2019 Code Foundry. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, Storyboardable {
    
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            // Configure Table View
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // MARK: -

    var didSignIn: (() -> Void)?
    var didSelectPhoto: ((Photo) -> Void)?
    var didBuyPhoto: ((Photo) -> Void)?
    
    // MARK: -
    
    private lazy var dataSource: [Photo] = [
        Photo(id: "pli", title: "Misery Ridge",                     url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/1.jpg"), price: 25.99),
        Photo(id: "jyg", title: "Grand Teton Sunset",               url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/2.jpg"), price: 15.99),
        Photo(id: "rdz", title: "Orange Icebergs",                  url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/3.jpg"), price: 27.99),
        Photo(id: "aqs", title: "Grand Teton Sunrise",              url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/4.jpg"), price: 35.99),
        Photo(id: "dfc", title: "Milky Tail",                       url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/5.jpg"), price: 18.99),
        Photo(id: "gbh", title: "White Sands National Monument",    url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/6.jpg"), price: 24.99),
        Photo(id: "hnj", title: "Stonehenge Storm",                 url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/7.jpg"), price: 25.99),
        Photo(id: "jkr", title: "Mountain Sunrise",                 url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/8.jpg"), price: 30.99),
        Photo(id: "pah", title: "Colours of Middle Earth",          url: URL(string: "https://cdn.cocoacasts.com/7ba5c3e7df669703cd7f0f0d4cefa5e5947126a8/9.jpg"), price: 50.99)
    ]

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Title
        title = "Photos"
        
        // Setup View
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update View
        updateView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        updateView()
    }
    
    private func updateView() {
        if UserDefaults.isSignedIn {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(signIn(_:)))
        }
        
        if let indexPaths = tableView.indexPathsForVisibleRows {
            // Update Table View
            tableView.reloadRows(at: indexPaths, with: .none)
        }
    }

    // MARK: - Actions
    
    @objc func signOut(_ sender: UIBarButtonItem) {
        // Update User Defaults
        UserDefaults.token = nil
        
        // Update View
        updateView()
    }
    
    @objc func signIn(_ sender: UIBarButtonItem) {
        didSignIn?()
    }
    
}

extension PhotosViewController: UITableViewDataSource {

    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseIdentifier, for: indexPath) as? PhotoTableViewCell else {
            fatalError("Unable to Dequeue Photo Table View Cell")
        }
        
        // Fetch Photo
        let photo = dataSource[indexPath.row]
        
        // Configure Cell
        cell.configure(title: photo.title, url: photo.url, didBuyPhoto: UserDefaults.didBuy(photo))
        cell.didBuy = { [weak self] in
            self?.didBuyPhoto?(photo)
        }
        
        return cell
    }

}

extension PhotosViewController: UITableViewDelegate {

    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Fetch Photo
        let photo = dataSource[indexPath.row]
        
        // Invoke Handler
        didSelectPhoto?(photo)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }

}
