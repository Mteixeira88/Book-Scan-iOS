//
//  BSItemResultView.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class BSItemResultView: UIView {
    
    let imagePreview = BSItemResultImage(frame: .zero)
    let bookTitleLabel = BSTitlteLabel(textAlignment: .left, fontSize: 22, weight: .bold)
    let authorLabel = BSTitlteLabel(textAlignment: .left, fontSize: 13)
    let publishedLabel = BSTitlteLabel(textAlignment: .left, fontSize: 13)
    let scoreLabel = BSScoreLabel(frame: .zero)
    let reviewsCountLabel = BSTitlteLabel(textAlignment: .left, fontSize: 13)
    let favoritesImage = BSFavoriteImage(frame: .zero)
    
    var isFavorite = false
    
    var book: Book!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(book: Book) {
        self.book = book
        bookTitleLabel.text = book.title.uppercased()
        authorLabel.text = "by \(book.author.uppercased())"
        publishedLabel.text = book.published != "" ? "first published in \(book.published)" : "Year not available"
        scoreLabel.text = "\(book.averageRating)"
        reviewsCountLabel.text = "in \(book.ratingCount) reviews"
        favoritesImage.image = SFSybmols.noFavorite
        favoritesImage.tintColor = .systemGray
        
        NetworkManager.shared.dowloadImage(from: book.bookImage) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imagePreview.image = image
            }
        }
    }
    
    @objc func setFavorites() {
        isFavorite = !isFavorite
        
        if isFavorite {
            PersistenceManager.updateWith(book: book, actionType: .add) {  [weak self] (error) in
                guard let self = self else { return }
                if error == nil {
                    self.favoritesImage.image = SFSybmols.isFavorite
                    self.favoritesImage.tintColor = .systemYellow
                }
            }
        } else {
            PersistenceManager.updateWith(book: book, actionType: .remove) { [weak self] (error) in
                guard let self = self else { return }
                
                if error == nil {
                    self.favoritesImage.image = SFSybmols.noFavorite
                    self.favoritesImage.tintColor = .systemGray
                }
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotifications.clickedFavoriteImage), object: nil, userInfo: nil)
    }
    
    func checkFavorites(of book: Book) {
        PersistenceManager.alreadyFavorite(of: book) { [weak self] isFav in
            guard let self = self else { return }
            if isFav {
                DispatchQueue.main.async {
                    self.isFavorite = true
                    self.favoritesImage.image = SFSybmols.isFavorite
                    self.favoritesImage.tintColor = .systemYellow
                }
            }
        }
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        let tapFavorites = UITapGestureRecognizer(target: self, action: #selector(setFavorites))
        favoritesImage.addGestureRecognizer(tapFavorites)
        
        addSubviews(imagePreview, bookTitleLabel, authorLabel, publishedLabel, scoreLabel, reviewsCountLabel, favoritesImage)
        
        NSLayoutConstraint.activate([
            imagePreview.centerYAnchor.constraint(equalTo: centerYAnchor),
            imagePreview.leadingAnchor.constraint(equalTo: leadingAnchor),
            imagePreview.widthAnchor.constraint(equalToConstant: 100),
            imagePreview.heightAnchor.constraint(equalTo: imagePreview.widthAnchor),
            
            bookTitleLabel.topAnchor.constraint(equalTo: imagePreview.topAnchor),
            bookTitleLabel.leadingAnchor.constraint(equalTo: imagePreview.trailingAnchor, constant: 20),
            bookTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bookTitleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            authorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: bookTitleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: bookTitleLabel.trailingAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 16),
            
            publishedLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            publishedLabel.leadingAnchor.constraint(equalTo: bookTitleLabel.leadingAnchor),
            publishedLabel.trailingAnchor.constraint(equalTo: bookTitleLabel.trailingAnchor),
            publishedLabel.heightAnchor.constraint(equalToConstant: 16),
            
            scoreLabel.topAnchor.constraint(equalTo: publishedLabel.bottomAnchor, constant: 10),
            scoreLabel.leadingAnchor.constraint(equalTo: bookTitleLabel.leadingAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: 75),
            scoreLabel.heightAnchor.constraint(equalToConstant: 33),
            
            reviewsCountLabel.bottomAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            reviewsCountLabel.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 8),
            reviewsCountLabel.trailingAnchor.constraint(equalTo: bookTitleLabel.trailingAnchor),
            reviewsCountLabel.heightAnchor.constraint(equalToConstant: 16),
            
            favoritesImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            favoritesImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            favoritesImage.widthAnchor.constraint(equalToConstant: 40),
            favoritesImage.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
