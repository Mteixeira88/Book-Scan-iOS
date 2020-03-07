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
    let favoriteImage = BSFavoriteImage(frame: .zero)
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        backgroundView.addGestureRecognizer(tap)
        getFavorites()
        
        configureUI()
        resultView.set(book: book)
    }
    
    func getFavorites() {
        PersistenceManager.alreadyFavorite(of: book) { [weak self] isFav in
            guard let self = self else { return }
            if isFav {
                DispatchQueue.main.async {
                    self.resultView.isFavorite = true
                    self.resultView.favoritesImage.image = SFSybmols.isFavorite
                    self.resultView.favoritesImage.tintColor = .systemYellow
                }
            }
        }
    }
    
    func configureUI() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        view.addSubview(resultView)
        view.addSubview(favoriteImage)
        
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
            resultView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

}

