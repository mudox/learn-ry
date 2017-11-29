// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit
import LearnRY

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

protocol StoryboardType {
  static var storyboardName: String { get }
}

extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

struct SceneType<T: Any> {
  let storyboard: StoryboardType.Type
  let identifier: String

  func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

struct InitialSceneType<T: Any> {
  let storyboard: StoryboardType.Type

  func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

protocol SegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
enum StoryboardScene {
  enum LaunchScreen: StoryboardType {
    static let storyboardName = "LaunchScreen"

    static let initialScene = InitialSceneType<UIViewController>(storyboard: LaunchScreen.self)
  }
  enum Login: StoryboardType {
    static let storyboardName = "Login"

    static let initialScene = InitialSceneType<LearnRY.LoginViewController>(storyboard: Login.self)

    static let loginViewController = SceneType<LearnRY.LoginViewController>(storyboard: Login.self, identifier: "loginViewController")
  }
  enum Main: StoryboardType {
    static let storyboardName = "Main"

    static let initialScene = InitialSceneType<UITabBarController>(storyboard: Main.self)

    static let chatViewController = SceneType<RCConversationViewController>(storyboard: Main.self, identifier: "chatViewController")

    static let contactInfoViewController = SceneType<LearnRY.ContactInfoViewController>(storyboard: Main.self, identifier: "contactInfoViewController")

    static let contactListViewController = SceneType<UITableViewController>(storyboard: Main.self, identifier: "contactListViewController")

    static let contactNavigationController = SceneType<UINavigationController>(storyboard: Main.self, identifier: "contactNavigationController")

    static let groupedChatListViewController = SceneType<LearnRY.GroupedChatListViewController>(storyboard: Main.self, identifier: "groupedChatListViewController")

    static let rootChatListViewController = SceneType<LearnRY.RootChatListViewController>(storyboard: Main.self, identifier: "rootChatListViewController")

    static let rootTabBarController = SceneType<UITabBarController>(storyboard: Main.self, identifier: "rootTabBarController")
  }
}

enum StoryboardSegue {
  enum Main: String, SegueType {
    case showChat
    case showContactInfo
    case showGroupedChatList
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
