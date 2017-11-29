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

extension The.UserDefaultsKey {


  /// User name of current user
  static let currentUserName = "currentUserName"

  /// A `Dictionary` of `[userName: userToken]`
  static let cachedUserTokens = "cachedUserTokens"

}

