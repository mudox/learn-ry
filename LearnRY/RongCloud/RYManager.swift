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

  // MARK: Constants
  static let appKey = "82hegw5u8dz5x"
  static let appSecret = "2OWrRo0pGe5"

  // MARK: Singleton
  static let shared = RYManager()
  private override init() { }

  // MARK: User Token
  static var cachedCurrentUserToken: String? {
    get {
      let key = The.UserDefaultsKey.cachedUserTokens
      guard let cachedTokens = The.userDefaults.dictionary(forKey: key) else {
        return nil
      }

      guard let id = FakeUser.current?.id else {
        return nil
      }

      return cachedTokens[id] as? String
    }
  }

  static func cacheToken(_ token: String, forUserID id: String) {
    let key = The.UserDefaultsKey.cachedUserTokens
    if var cachedTokens = The.userDefaults.dictionary(forKey: key) {
      cachedTokens[id] = token
      The.userDefaults.set(cachedTokens, forKey: key)
    } else {
      The.userDefaults.set([id: token], forKey: key)
    }
    The.userDefaults.synchronize()
  }

  static func getCurrentUserToken() -> Single<String> {
    return Single<String>.create { single -> Disposable in

      if let token = RYManager.cachedCurrentUserToken {
        jack.debug("use cached token")
        single(.success(token))
        return Disposables.create()
      }

      jack.debug("no token cacheed for \(FakeUser.current.fullName), request from server")

      let id = FakeUser.current.id
      let name = FakeUser.current.fullName
      let cancellable = MoyaProvider<RYTarget>().request(.getUserToken(id: id, name: name)) {
        result in

        switch result {
        case .success(let response):
          do {
            let json = JSON(response.data)
            let token: String = try json.take(from: "token")
            RYManager.cacheToken(token, forUserID: id)
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

  // MARK: - SDK

  static func initSDK() {
    let sdk = RCIM.shared()!
    sdk.initWithAppKey(appKey)
    sdk.userInfoDataSource = shared
//    sdk.groupInfoDataSource = shared
//    sdk.enableTypingStatus = true
//    sdk.enableMessageRecall = true
//    sdk.enableMessageMentioned = true
//    sdk.enablePersistentUserInfoCache = true
  }


  static func connect(with token: String) -> Completable {
    return Completable.create { completable in
      RCIM.shared().connect(
        withToken: token,
        success: { userID in
          completable(.completed)
        },
        error: { errorCode in
          completable(.error(RYManagerError.connection(code: errorCode)))
        },
        tokenIncorrect: {
          completable(.error(RYManagerError.invalidToken))
        })

      return Disposables.create()
    } // Completable.create
  }

}

// MARK: - RCIMUserInfoDataSource
extension RYManager: RCIMUserInfoDataSource {

  func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
    if let user = FakeUser.all[userId] {
      completion(user.rcUserInfo)
    } else {
      jack.warn("no user info for user ID: \(userId)")
      completion(nil)
    }
  }

}

