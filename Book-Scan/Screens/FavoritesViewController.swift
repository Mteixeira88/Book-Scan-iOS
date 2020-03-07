//
//  FavoritesViewController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    let searchController = BSSearchController(searchResultsController: nil)
    
    let tableView = UITableView()
    
    var books = [Book]()
    var filterBooks = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        searchController.delegateSearch = self
        addSearchBar(with: searchController)
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBooks()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        tableView.frame = view.bounds
        tableView.rowHeight = 150
        tableView.register(ItemResultCell.self, forCellReuseIdentifier: ItemResultCell.reuseID)
    }
    
    func getBooks() {
        PersistenceManager.fetchData { [weak self] books in
            guard let self = self else { return }
            self.books = books
            self.tableView.reloadData()
        }
    }
}

extension FavoritesViewController: BSSearchControllerDelegate {
    func didFinishSearch(with result: [Book], error: String?) {
        if error != nil {
            print(error!)
            return
        }
        
        guard result.count != 1  else {
            presentBSResultOnMainThread(book: result[0])
            return
        }
        
        
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemResultCell.reuseID) as! ItemResultCell
        let book = books[indexPath.row]
        cell.cellView.set(book: book)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        PersistenceManager.updateWith(book: books[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let _ = error else {
                self.books.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
        }
        
    }
    
}
