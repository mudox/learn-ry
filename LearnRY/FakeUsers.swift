//
// FakeUsers.swift
// LearnRY
//
// Created by Mudox on 24/11/2017.
// Copyright © 2017 Mudox. All rights reserved.
//

import UIKit
import iOSKit
import RandomUser

struct FakeUsers {

  static let allUsers: [RCUserInfo] = {
    let url = The.mainBundle.url(forResource: "users", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let randomUsers = try! JSONDecoder().decode([RandomUser.User].self, from: data)

    return randomUsers.map { (user: RandomUser.User) -> RCUserInfo in
      return RCUserInfo(
        userId: user.login.username,
        name: "\(user.name.first.capitalized) \(user.name.last.capitalized)",
        portrait: user.picture.large.absoluteString
      )
    }
  }()

  static var currentUser: RCUserInfo { return allUsers.first! }
  static var otherUsers: [RCUserInfo] { return Array(allUsers[1...]) }

  static func user(withID id: String) -> RCUserInfo? {
    let users = allUsers.filter { $0.userId == id }
    return users.first
  }

}

