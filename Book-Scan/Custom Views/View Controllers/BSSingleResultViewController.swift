//
//  BSSingleResultViewController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class BSSingleResultViewController: UIViewController {

    let containerView = BSSingleResultViewContainer()
    let backgroundView = UIView()
    let resultView = BSItemResultView()
    let favoriteImage = UIImageView()
    
    var isFavorite = false
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        backgroundView.addGestureRecognizer(tap)
        
        let tapFavorites = UITapGestureRecognizer(target: self, action: #selector(setFavorites))
        favoriteImage.isUserInteractionEnabled = true
        favoriteImage.addGestureRecognizer(tapFavorites)
        
        configureUI()
        resultView.set(book: book)
        
        getFavorites()
    }
    
    func getFavorites() {
        favoriteImage.image = SFSybmols.noFavorite
        
        PersistenceManager.alreadyFavorite(of: book) { isFav in
            if isFav {
                DispatchQueue.main.async {
                    self.isFavorite = true
                    self.favoriteImage.image = SFSybmols.isFavorite
                }
            }
        }
    }
    
    func configureUI() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        view.addSubview(resultView)
        view.addSubview(favoriteImage)
        
        favoriteImage.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: view.frame.height),
            backgroundView.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 150),
            containerView.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            resultView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            resultView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            resultView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            resultView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            favoriteImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            favoriteImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            favoriteImage.widthAnchor.constraint(equalToConstant: 40),
            favoriteImage.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func setFavorites() {
        isFavorite = !isFavorite
        favoriteImage.image = isFavorite ? SFSybmols.isFavorite : SFSybmols.noFavorite
        
        if isFavorite {
            PersistenceManager.updateWith(book: book, actionType: .add) { (error) in
                if error != nil {
                    print(error)
                }
            }
        } else {
            PersistenceManager.updateWith(book: book, actionType: .remove) { (error) in
                if error != nil {
                    print(error)
                }
            }
        }
        
    }

}

