//
//  FavoritesViewController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    let searchController = BSSearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        searchController.delegateSearch = self
        addSearchBar(with: searchController)
    }
}

extension FavoritesViewController: BSSearchControllerDelegate {
    func didTapSearchButton(for query: String) {
//        presentBSResultOnMainThread()
    }
}
