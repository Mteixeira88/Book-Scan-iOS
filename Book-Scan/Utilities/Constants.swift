//
//  Constants.swift
//  Book-Scan
//
//  Created by Miguel Teixeira on 05/03/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

enum Network {
    static let keyGoodReads = "6uEyilxVLXRueBiQKDBmfg"
}

enum SFSybmols {
    static let searchGlass = UIImage(systemName: "magnifyingglass")
    static let noFavorite = UIImage(systemName: "star")
    static let isFavorite = UIImage(systemName: "star.fill")
}

enum NSNotifications {
    static let clickedFavoriteImage = "clickedFavoriteImage"
}

enum Images {
    static let placholderImage = UIImage(named: "placeholder")
}

enum Colors {
    static let mainColor = UIColor.systemPink
    static let greenColor = UIColor(named: "Green")
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isIpad = idiom == .phone && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
    
    static func isSmalliPhone() -> Bool {
        return isiPhone8Zoomed || isiPhoneSE
    }
}
