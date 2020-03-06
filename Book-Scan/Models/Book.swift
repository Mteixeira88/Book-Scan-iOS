//
//  Book.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 06/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import Foundation
import SWXMLHash

struct Book: XMLIndexerDeserializable {
    let id: Int
    let averageRating: String
    let ratingCount: Int
    let published: String
    let title: String
    let bookImage: String
    let author: String

    static func deserialize(_ node: XMLIndexer) throws -> Book {
        var year = "0"
        if let yearCheck = node["original_publication_year"].element?.text {
            year = yearCheck
        }
        return try Book(
            id: node["id"].value(),
            averageRating: node["average_rating"].value(),
            ratingCount: node["ratings_count"].value(),
            published: year,
            title: node["best_book"]["title"].value(),
            bookImage: node["best_book"]["image_url"].value(),
            author: node["best_book"]["author"]["name"].value()
        )
    }
}
