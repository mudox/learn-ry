//
//  AppDelegate.swift
//  LearnRY
//
//  Created by Mudox on 12/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import UIKit
import iOSKit
import JacKit
import RxSwift

fileprivate let jack = Jack.with(levelOfThisFile: .debug)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  var disposeBag = DisposeBag()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    application.mdx_greet()
    RYManager.initSDK()

    window = UIWindow(frame: The.mainScreen.bounds)

    if FakeUser.current == nil {
      jack.info("no current user, show login interface")
      logout()
    } else {
      jack.info("login automatically as <\(FakeUser.current.fullName)>")
      login()
    }

    window?.makeKeyAndVisible()
    return true
  }


  /// Get current user token, if not.
  /// Then connect to RongCloud server.
  /// Transition to chat interface if everything goes fine.
  func login() {
    window!.rootViewController = StoryboardScene.Main.launchScreenViewController.instantiate()

    // get current token, if noy, and then connect to RongCloud server
    RYManager
      .getCurrentUserToken()
      .asObservable()
      .flatMapLatest { token in
        return RYManager.connect(with: token)
      }
      .asCompletable()
      .subscribe(
        onCompleted: {
          DispatchQueue.main.async { [weak self] in
            self?.window?.rootViewController = StoryboardScene.Main.rootTabBarController.instantiate()
          }
        },
        onError: { error in
          jack.error("enter chat list failed with:\n\(error)")
        }
      )
      .disposed(by: disposeBag)
  }

  /// Remove current user info, show login interface.
  func logout() {
    FakeUser.current = nil
    window!.rootViewController = StoryboardScene.Login.loginViewController.instantiate()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

    The.userDefaults.synchronize()
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

