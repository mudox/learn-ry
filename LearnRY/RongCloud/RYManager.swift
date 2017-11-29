//
//  RYManager.swift
//  LearnRY
//
//  Created by Mudox on 25/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import Foundation
import Moya
import iOSKit
import SwiftyJSON
import RxSwift
import JacKit

fileprivate let jack = Jack.with(levelOfThisFile: .debug)

enum RYManagerError: Error {
  case connection(code: RCConnectErrorCode)
  case invalidToken
  case currentUser(description: String)
}

class RYManager: NSObject {

  // MARK: - Constants
  static let appKey = "82hegw5u8dz5x"
  static let appSecret = "2OWrRo0pGe5"

  // MARK: - Singleton
  static let shared = RYManager()
  private override init() { }

  // MARK: - User Token
  static var cachedCurrentUserToken: String? {
    get {
      guard let dict = The.userDefaults.dictionary(forKey: "userTokens") else {
        return nil
      }

      guard let id = FakeUser.current?.id else {
        return nil
      }

      return dict[id] as? String
    }
  }

  static func cacheToken(_ token: String, forUserName name: String) {
    if var tokens = The.userDefaults.dictionary(forKey: The.UserDefaultsKey.cachedUserTokens) {
      tokens[name] = token
      The.userDefaults.set(tokens, forKey: The.UserDefaultsKey.cachedUserTokens)
    } else {
      The.userDefaults.set([name: token], forKey: The.UserDefaultsKey.cachedUserTokens)
    }
  }

  var getCurrentUserToken: Single<String> {
    return Single<String>.create { single -> Disposable in

      if let token = RYManager.cachedCurrentUserToken {
        single(.success(token))
        jack.debug("use cached token")
        return Disposables.create()
      }

      jack.debug("request token from server")

      let id = FakeUser.current.id
      let name = FakeUser.current.fullName
      let cancellable = MoyaProvider<RYTarget>().request(.getUserToken(id: id, name: name)) {
        result in

        switch result {
        case .success(let response):
          do {
            let json = JSON(response.data)
            let token: String = try json.take(from: "token")
            RYManager.cacheToken(token, forUserName: name)
            single(.success(token))
          } catch {
            single(.error(error))
          }
        case .failure(let error):
          single(.error(error))
        }
      }

      return Disposables.create {
        cancellable.cancel()
      }

    } // Single.create
  }


  static func initSDK() {
    let sdk = RCIM.shared()!
    sdk.initWithAppKey(appKey)
    sdk.userInfoDataSource = shared
//    sdk.groupInfoDataSource = shared
    sdk.enableTypingStatus = true
//    sdk.enableMessageRecall = true
//    sdk.enableMessageMentioned = true
    sdk.enablePersistentUserInfoCache = true
  }


  func connectToServer(with token: String) -> Completable {
    return Completable.create { emit in
      RCIM.shared().connect(
        withToken: token,
        success: { userID in
          emit(.completed)
        },
        error: { errorCode in
          emit(.error(RYManagerError.connection(code: errorCode)))
        },
        tokenIncorrect: {
          emit(.error(RYManagerError.invalidToken))
        })

      return Disposables.create()
    } // Completable.create
  }

}

// MARK: - RCIMUserInfoDataSource
extension RYManager: RCIMUserInfoDataSource {

  func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
    completion(FakeUser.all[userId]?.rcUserInfo)
  }

}

