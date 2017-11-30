//
//  The.swift
//  LearnRY
//
//  Created by Mudox on 28/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import iOSKit

extension The {
  
  static var appDelegate: AppDelegate { return The.app.delegate as! AppDelegate }
  
}

extension The {
  
  static var chatNavigationController: UINavigationController {
    return (The.mainWindow.rootViewController as! UITabBarController).viewControllers!.first as! UINavigationController
  }
  
  static var rootTabBarController: UITabBarController {
    return The.mainWindow.rootViewController as! UITabBarController
  }
  
}

extension The.UserDefaultsKey {
  
  /// User name of current user
  static let currentUserID = "currentUserName"

  /// A `Dictionary` of `[userID: userToken]`
  static let cachedUserTokens = "cachedUserTokens"

}

