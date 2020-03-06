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

class BSSearchController: UISearchController {
    
    var delegateSearch: BSSearchControllerDelegate!
    var resultType = 0
    
    override func loadView() {
        super.loadView()
        searchBar.placeholder = "Search for title or ISBN"
        searchBar.tintColor = Colors.mainColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.delegate = self
    }
}

extension BSSearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NetworkManager.shared.genericRequest(for: Book.self, url: "&q=\(textField.text!.replacingOccurrences(of: " ", with: "+"))") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                self.delegateSearch.didFinishSearch(with: books, error: nil)
            case .failure(let error):
                self.delegateSearch.didFinishSearch(with: [], error: error.rawValue)
            }
        }
        isActive = false
        return true
    }
}
