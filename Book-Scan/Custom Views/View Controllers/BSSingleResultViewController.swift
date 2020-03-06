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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        backgroundView.addGestureRecognizer(tap)
        
        resultView.set(bookTitle: "O Último Cabalista de Lisboa", author: "Richard Zimmler", published: "1996", score: "3.86", reviewsCount: "261")
        
        configureUI()
    }
    
    func configureUI() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        view.addSubview(resultView)
        
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

