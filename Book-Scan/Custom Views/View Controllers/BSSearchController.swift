//
//  BSSearchController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

protocol BSSearchControllerDelegate: class {
    func didFinishSearch(with result: [Book], error: String?)
}

class BSSearchController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var delegateSearch: BSSearchControllerDelegate!
    var resultType = 0
    
    override func loadView() {
        super.loadView()
        addSearchBar(with: searchController)
        searchController.searchBar.placeholder = "Search for title or ISBN"
        searchController.searchBar.tintColor = Colors.mainColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.searchTextField.delegate = self
    }
}

extension BSSearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NetworkManager.shared.genericRequest(for: Book.self, url: "&q=\(textField.text!.replacingOccurrences(of: " ", with: "+"))") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                guard books.count != 1  else {
                    self.presentBSResultOnMainThread(book: books[0])
                    return
                }
                
                DispatchQueue.main.async {
                    let destVC = MultipleResultsViewController()
                    let navController = UINavigationController(rootViewController: destVC)
                    
                    destVC.books = books
                    self.present(navController, animated: true)
                }
            case .failure(let error):
                self.delegateSearch.didFinishSearch(with: [], error: error.rawValue)
            }
        }
        searchController.isActive = false
        return true
    }
}
