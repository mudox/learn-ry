//
// FakeUsers.swift
// LearnRY
//
// Created by Mudox on 24/11/2017.
// Copyright © 2017 Mudox. All rights reserved.
//

import UIKit
import iOSKit
import SwiftyJSON

struct FakeUser {

  enum Gender: String {
    case male = "male"
    case female = "female"
  }

  // nature name
  let firstName: String
  let lastName: String
  var fullName: String { return "\(firstName) \(lastName)" }

  // login info
  let id: String
  let password: String

  let gender: Gender
  let birthday: String

  // location
  let state: String
  let city: String
  let street: String
  let countryCode: String

  // contact info
  let phone: String
  let email: String

  let avatarURL: URL

  let friends: [String]

}

// MARK: - type properties
extension FakeUser {

  static let all: [String: FakeUser] = {
    let url = The.mainBundle.url(forResource: "users", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let json = try! JSON(data: data)

    return json.dictionaryValue.mapValues { userJSON in
      return FakeUser(
        firstName: userJSON["name", "first"].stringValue.capitalized,
        lastName: userJSON["name", "last"].stringValue.capitalized,

        id: userJSON["login", "username"].stringValue,
        password: userJSON["login", "password"].stringValue,

        gender: Gender(rawValue: userJSON["gender"].stringValue)!,
        birthday: userJSON["dob"].stringValue,

        state: userJSON["location", "state"].stringValue.capitalized,
        city: userJSON["location", "city"].stringValue.capitalized,
        street: userJSON["location", "street"].stringValue.capitalized,
        countryCode: userJSON["nat"].stringValue,

        phone: userJSON["phone"].stringValue,
        email: userJSON["email"].stringValue,

        avatarURL: URL(string: userJSON["picture", "large"].stringValue)!,

        friends: userJSON["friends"].arrayValue.map { $0.stringValue }
      )
    }

  }()

  /// must have non-nil value after app finished launching
  static var current: FakeUser! {
    get {
      guard let userID = The.userDefaults.string(forKey: The.UserDefaultsKey.currentUserID) else {
        return nil
      }
      return FakeUser.all[userID]!
    }
    set {
      The.userDefaults.set(newValue?.id, forKey: The.UserDefaultsKey.currentUserID)
    }
  }

}

// MARK: - to RCUserInfo
extension FakeUser {

  var rcUserInfo: RCUserInfo {
    return RCUserInfo(
      userId: id,
      name: "\(firstName) \(lastName)",
      portrait: avatarURL.absoluteString
    )
  }

}
