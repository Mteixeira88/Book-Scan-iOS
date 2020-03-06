//
//  BSSearchController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

protocol BSSearchControllerDelegate: class {
    func didTapSearchButton(for query: String)
}

class BSSearchController: UISearchController {
    
    var delegateSearch: BSSearchControllerDelegate!
    
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
        delegateSearch.didTapSearchButton(for: textField.text!)
        isActive = false
        return true
    }
}
