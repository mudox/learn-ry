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
  enum Chat: StoryboardType {
    static let storyboardName = "Chat"

    static let rootChatListViewController = SceneType<LearnRY.RootChatListViewController>(storyboard: Chat.self, identifier: "rootChatListViewController")
  }
  enum Contacts: StoryboardType {
    static let storyboardName = "Contacts"

    static let contactInfoViewController = SceneType<LearnRY.ContactInfoViewController>(storyboard: Contacts.self, identifier: "contactInfoViewController")

    static let contactListViewController = SceneType<LearnRY.ContactListTableViewController>(storyboard: Contacts.self, identifier: "contactListViewController")
  }
  enum LaunchScreen: StoryboardType {
    static let storyboardName = "LaunchScreen"
  }
  enum Login: StoryboardType {
    static let storyboardName = "Login"

    static let loginViewController = SceneType<LearnRY.LoginViewController>(storyboard: Login.self, identifier: "loginViewController")
  }
  enum Main: StoryboardType {
    static let storyboardName = "Main"

    static let currentUserViewController = SceneType<LearnRY.CurrentUserViewController>(storyboard: Main.self, identifier: "currentUserViewController")

    static let launchScreenViewController = SceneType<LearnRY.LaunchScreenViewController>(storyboard: Main.self, identifier: "launchScreenViewController")

    static let rootTabBarController = SceneType<UITabBarController>(storyboard: Main.self, identifier: "rootTabBarController")
  }
}

enum StoryboardSegue {
  enum Contacts: String, SegueType {
    case showContactInfo
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
