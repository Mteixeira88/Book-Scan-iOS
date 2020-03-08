//
//  BSTabBarController.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class BSTabBarController: UITabBarController {
    
    override func loadView() {
        super.loadView()
        UITabBar.appearance().tintColor = Colors.mainColor
        viewControllers = [createFavoritesListNC(), createScanNC()]
    }
    
    func createScanNC() -> UINavigationController {
        let scanVC = ScanViewController()
        scanVC.tabBarItem = UITabBarItem(title: "Scan ISBN", image: SFSybmols.searchGlass, tag: 0)
        return UINavigationController(rootViewController: scanVC)
    }
    
    func createFavoritesListNC() -> UINavigationController {
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesVC)
    }
}
