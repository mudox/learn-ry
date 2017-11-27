//
//  FakeServer.swift
//  LearnRY
//
//  Created by Mudox on 24/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import Foundation
import Moya
import iOSKit
import CryptoSwift

enum RYTarget {
  case getUserToken(id: String, name: String)
  case postPrivateTextMessage(String, from: String, to: String)
  case postPrivateImageMessage(thumnail: String, image: String, from: String, to: String)
  case postPrivateCardMessage(title: String, text: String, image: String, url: String, from: String, to: String)
}

extension RYTarget: TargetType {

  var baseURL: URL { return URL(string: "http://api.cn.ronghub.com")! }

  var path: String {
    switch self {
    case .getUserToken:
      return "/user/getToken.json"
    case
       .postPrivateTextMessage,
       .postPrivateImageMessage,
       .postPrivateCardMessage:
      return "/message/private/publish.json"
    }
  }

  var method: Moya.Method {
    return .post
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case let .getUserToken(id: id, name: name):
      return .requestParameters(
        parameters: ["userId": id, "name": name],
        encoding: URLEncoding.httpBody
      )
    case let .postPrivateTextMessage(message, from: fromUserID, to: toUserID):
      return .requestParameters(
        parameters: [
          "fromUserId": fromUserID,
          "toUserId": toUserID,
          "objectName": "RC:TxtMsg",
          "content": "{\"content\": \"\(message)\", \"extra\": \"none\"}"
        ],
        encoding: URLEncoding.httpBody
      )
    case let .postPrivateImageMessage(thumnail: thumnail, image: image, from: fromUserID, to: toUserID):
      return .requestParameters(
        parameters: [
          "fromUserId": fromUserID,
          "toUserId": toUserID,
          "objectName": "RC:ImgMsg",
          "content": "{\"content\": \"\(thumnail)\", \"imageUri\": \"\(image)\",\"extra\": \"none\"}"
        ],
        encoding: URLEncoding.httpBody
      )

    case let .postPrivateCardMessage(title, text, image, url, fromUserID, toUserID):
      return .requestParameters(
        parameters: [
          "fromUserId": fromUserID,
          "toUserId": toUserID,
          "objectName": "RC:ImgTextMsg",
          "content": "{\"title\": \"\(title)\", \"content\": \"\(text)\", \"imageUri\": \"\(image)\", \"url\": \"\(url)\", \"extra\": \"none\"}"
        ],
        encoding: URLEncoding.httpBody
      )
    }
  }

  var headers: [String: String]? {
    let nonce = arc4random()
    let timestamp = Int(Date().timeIntervalSince1970)
    let signature = "\(RYManager.appSecret)\(nonce)\(timestamp)".sha1()

    return [
      "App-Key": RYManager.appKey,
      "Timestamp": "\(timestamp)",
      "Nonce": "\(nonce)",
      "Signature": signature,
    ]
  }

}
