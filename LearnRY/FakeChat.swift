//
//  FakeMessage.swift
//  LearnRY
//
//  Created by Mudox on 26/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import Foundation
import Moya
import RandomKit
import JacKit
import RxSwift
import iOSKit

fileprivate let jack = Jack.with(levelOfThisFile: .verbose)

private let words = "alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt neque dolorem ipsum quia dolor sit amet consectetur adipisci velit sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem ut enim ad minima veniam quis nostrum exercitationem ullam corporis nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam nisi ut aliquid ex ea commodi consequatur quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi id est laborum et dolorum fuga et harum quidem rerum facilis est et expedita distinctio nam libero tempore cum soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est qui minus id quod maxime placeat facere possimus omnis voluptas assumenda est omnis dolor repellendus temporibus autem quibusdam et aut consequatur vel illum qui dolorem eum fugiat quo voluptas nulla pariatur at vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae itaque earum rerum hic tenetur a sapiente delectus ut aut reiciendis voluptatibus maiores doloribus asperiores repellat".components(separatedBy: " ")

func randomSentence() -> String {
  var r = ARC4Random.default
  return (1...Int.random(in: 2...15, using: &r))
    .map({ _ in words.random(using: &r)! })
    .joined(separator: " ")
}

func randomWord() -> String {
  return words.random(using: &ARC4Random.default)!
}

func randomImageInfo() -> (thumbnail: String, url: String) {
  var r = ARC4Random.default
  let width = (4...8).random(using: &r)! * 40
  let height = (4...8).random(using: &r)! * 40
  let url = URL(string: "https://placeimg.com/\(width)/\(height)/any")!
  let data = try! Data(contentsOf: url)
  return (data.base64EncodedString(options: []), url.absoluteString)
}

struct FakeChat {

  enum Status {
    case running, cancelling, notRunning
  }

  static let status = Variable(Status.notRunning)

  static func toggle() {
    switch status.value {
    case .running:
      cancel()
    case .cancelling:
      jack.warn("called when status is `.cancelling`")
    case .notRunning:
      start()
    }
  }

  static func start() {
    assert(status.value == .notRunning)
    status.value = .running

    DispatchQueue.global(qos: .background).async {
      while true {
        // check cancellation
        guard status.value == .running else {
          assert(status.value == .cancelling)
          status.value = .notRunning
          return
        }

        var r = ARC4Random.default
        Thread.sleep(forTimeInterval: TimeInterval.random(in: 1...8, using: &r))

        let dice = Int.random(in: 0..<10, using: &r)!
        if dice < 2 {
          postPrivateImageMessage()
        } else if dice < 5 {
          postPrivateCardMessage()
        } else {
          postPrivateTextMessage()
        }
      } // while true
    }

  }

  static func postPrivateTextMessage() {
    var r = ARC4Random.default
    let from =  FakeUsers.otherUsers.random(using: &r)!
    let to =  FakeUsers.currentUser
    let message = randomSentence()
    _ = MoyaProvider<RYTarget>().request(.postPrivateTextMessage(message, from: from.userId!, to: to.userId!)) {
      result in
      switch result {
      case .success:
        jack.debug("""
          posting text message succeeded:
          - from: \(from.name!)
          - to: \(to.name!)
          - message: \(message)
          """)
      case .failure(let error):
        jack.warn("posting text message failed with:\n\(error)")
      }
    }
  }

  static func postPrivateImageMessage() {
    var r = ARC4Random.default
    let from =  FakeUsers.otherUsers.random(using: &r)!
    let to =  FakeUsers.currentUser
    let (thumbnail, imageString) = randomImageInfo()
    _ = MoyaProvider<RYTarget>().request(.postPrivateImageMessage(thumnail: thumbnail, image: imageString, from: from.userId!, to: to.userId!)) {
      result in
      switch result {
      case .success:
        jack.debug("""
          posting image message succeeded:
          - from: \(from.name!)
          - to: \(to.name!)
          """)
      case .failure(let error):
        jack.warn("posting image message failed with:\n\(error)")
      }
    }
  }
  
  static func postPrivateCardMessage() {
    var r = ARC4Random.default
    let from =  FakeUsers.otherUsers.random(using: &r)!
    let to =  FakeUsers.currentUser
    let (_, imageString) = randomImageInfo()
    let url = "https://github.com/mudox"
    let title = randomWord()
    let message = randomSentence()
    
    _ = MoyaProvider<RYTarget>().request(.postPrivateCardMessage(title: title, text: message, image: imageString, url: url, from: from.userId!, to: to.userId!)) {
      result in
      switch result {
      case .success:
        jack.debug("""
          posting card message succeeded:
          - from: \(from.name!)
          - to: \(to.name!)
          - title: \(title)
          - message: \(message)
          """)
      case .failure(let error):
        jack.warn("posting card message failed with:\n\(error)")
      }
    }
  }

  static func cancel() {
    assert(status.value == .running)
    status.value = .cancelling
  }

}
