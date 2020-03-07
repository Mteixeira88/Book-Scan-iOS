//
//  File.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentBSResultOnMainThread(book: Book) {
        DispatchQueue.main.async {
            let resultVC = BSSingleResultViewController()
            resultVC.book = book
            resultVC.modalPresentationStyle = .overFullScreen
            resultVC.modalTransitionStyle = .crossDissolve
            self.present(resultVC, animated: true)
        }
    }
    
    func addSearchBar(with searchController: BSSearchController) {
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }
}
