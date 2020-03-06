//
//  PersistenceManager.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 06/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit
import CoreData

enum PersistenceActionType {
    case add, remove
}

class PersistenceManager {
    static func updateWith(book: Book, actionType: PersistenceActionType, completed: @escaping(String?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        switch actionType {
        case .add:
            let entity = NSEntityDescription.entity(forEntityName: "BookCoreData", in: managedContext)!
            let bookEntity = NSManagedObject(entity: entity, insertInto: managedContext)
            
            bookEntity.setValue(book.id, forKeyPath: "id")
            bookEntity.setValue(book.author, forKeyPath: "author")
            bookEntity.setValue(book.averageRating, forKeyPath: "averageRating")
            bookEntity.setValue(book.bookImage, forKeyPath: "bookImage")
            bookEntity.setValue(book.published, forKeyPath: "published")
            bookEntity.setValue(book.ratingCount, forKeyPath: "ratingCount")
            bookEntity.setValue(book.title, forKeyPath: "title")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                completed("Could not save. \(error), \(error.userInfo)")
            }
        case .remove:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookCoreData")
            fetchRequest.predicate = NSPredicate(format: "id = %@", "\(book.id)")
            
            do {
                let objects = try managedContext.fetch(fetchRequest)
                for object in objects as! [NSManagedObject] {
                    managedContext.delete(object)
                }
                try managedContext.save()
            } catch let error as NSError {
                completed("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func fetchData(completed: @escaping([Book]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookCoreData")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            var bookArray = [Book]()
            for data in result as! [BookCoreData] {
                let favBook = Book(id: Int(data.id), averageRating: data.averageRating!, ratingCount: Int(data.ratingCount), published: data.published!, title: data.title!, bookImage: data.bookImage!, author: data.author!)
                bookArray.append(favBook)
            }
            completed(bookArray)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
