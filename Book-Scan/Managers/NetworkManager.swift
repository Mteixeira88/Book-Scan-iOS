//
//  NetworkManager.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 06/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit
import SWXMLHash

enum NetworkError: String, Error {
    case invalidUsername = "This book created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case dataInvalid = "Data received invalid. Please try again"
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://www.goodreads.com/search.xml?key=\(Network.keyGoodReads)"
    let cache = NSCache<NSString, UIImage>()
    
    func genericRequest<T: XMLIndexerDeserializable>(for: T.Type = T.self, url: String, completed: @escaping(Result<[T], NetworkError>) -> Void) {
        let endpoint = baseURL + url
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.dataInvalid))
                return
            }
            let xml = SWXMLHash.parse(data)
            print(type(of: xml))
            let result = xml["GoodreadsResponse"]["search"]["results"]["work"]
            
            do {
                let book: [T] = try result.value()
                completed(.success(book))
            }
            catch {
                completed(.failure(.dataInvalid))
            }
        }
        
        task.resume()
    }
    
    func dowloadImage(from urlString: String, completed: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        })
        
        task.resume()
    }
    
}

