//
//  BSFavoriteImage.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 07/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class BSFavoriteImage: UIImageView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        image = SFSybmols.noFavorite
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .systemBackground
    }
    
    func update(isFavorite: Bool) {
        var isFavorite = isFavorite
        isFavorite = !isFavorite
        
        if isFavorite {
            image = SFSybmols.isFavorite
            tintColor = .systemYellow
        } else {
            
            image = SFSybmols.noFavorite
            tintColor = .systemBackground
        }
        
    }
    
}
