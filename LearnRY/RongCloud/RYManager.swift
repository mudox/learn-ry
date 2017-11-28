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
}

class RYManager: NSObject {

  static let appKey = "82hegw5u8dz5x"
  static let appSecret = "2OWrRo0pGe5"

  static var userToken: String? {
    get {
      let ud = UserDefaults.standard
      return ud.string(forKey: "currentUserToken")
    }
    set {
      let ud = UserDefaults.standard
      ud.set(newValue, forKey: "currentUserToken")
    }
  }

  static let shared = RYManager()
  private override init() { }

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

  var getCurrentUserToken: Single<String> {
    return Single<String>.create { single -> Disposable in

      if let token = RYManager.userToken {
        single(.success(token))
        jack.debug("use cached token")
        return Disposables.create()
      }

      jack.debug("request token from server")

      let id =  FakeUsers.currentUser.userId!
      let name =  FakeUsers.currentUser.name!
      let cancellable = MoyaProvider<RYTarget>().request(.getUserToken(id: id, name: name)) {
        result in
        
        switch result {
        case .success(let response):
          do {
            let json = JSON(response.data)
            let token: String = try json.take(from: "token")
            RYManager.userToken = token
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
    completion( FakeUsers.user(withID: userId))
  }

}

