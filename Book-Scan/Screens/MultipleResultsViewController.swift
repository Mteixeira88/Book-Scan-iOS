//
//  MultipleResultsViewController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 07/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class MultipleResultsViewController: UIViewController {
    let tableView = UITableView()
    
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        configureViewController()
        configureTableView()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismssVC))
        navigationItem.rightBarButtonItem = doneButton
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
    
    @objc func dismssVC() {
        dismiss(animated: true)
    }
}

extension MultipleResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemResultCell.reuseID) as! ItemResultCell
        let book = books[indexPath.row]
        cell.cellView.set(book: book)
        cell.cellView.checkFavorites(of: book)
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

