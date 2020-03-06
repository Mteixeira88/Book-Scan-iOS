//
//  ScanViewController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {
    let searchController = BSSearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.delegateSearch = self
        addSearchBar(with: searchController)
    }
}

extension ScanViewController: BSSearchControllerDelegate {
    func didTapSearchButton(for query: String) {
        NetworkManager.shared.genericRequest(for: Book.self, url: "&q=\(query)") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                print(books)
                if books.count == 1 {
                    self.presentBSResultOnMainThread(book: books[0])
                }
            case .failure(_):
                print("Something went wrong")
            }
        }
    }
}
