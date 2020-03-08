//
//  FavoritesViewController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: BSSearchController {
    
    let tableView = UITableView()
    
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        configureTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(getBooks), name: NSNotification.Name(rawValue: NSNotifications.clickedFavoriteImage), object: nil)
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
    
    @objc func getBooks() {
        PersistenceManager.fetchData { [weak self] books in
            guard let self = self else { return }
            self.books = books
            self.tableView.reloadData()
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
        cell.cellView.favoritesImage.removeFromSuperview()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        PersistenceManager.updateWith(book: books[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let _ = error else {
                DispatchQueue.main.async {
                    self.books.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                }
                return
            }
        }
        
    }
    
}
