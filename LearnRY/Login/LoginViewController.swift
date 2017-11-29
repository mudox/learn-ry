//
//  LoginViewController.swift
//  LearnRY
//
//  Created by Mudox on 28/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import UIKit
import iOSKit
import Kingfisher

private var loginUsers: [FakeUser] = {
  return Array(FakeUser.all.values)
}()

class LoginViewController: UIViewController {

  @IBOutlet weak var avatarView: UIImageView!

  @IBOutlet weak var userNameField: UITextField!
  @IBOutlet weak var userNamePlaceHolder: UILabel!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passwordPlaceholder: UILabel!

  @IBOutlet weak var loginButton: UIButton!

  @IBOutlet weak var usersTableView: UITableView!


  override func viewDidLoad() {
    super.viewDidLoad()

    avatarView.layer.cornerRadius = avatarView.bounds.height / 2
    avatarView.layer.masksToBounds = true

    loginButton.layer.cornerRadius = 4
    usersTableView.backgroundColor = UIColor(white: 1, alpha: 0)

    let nib = UINib(nibName: "LoginUserTableViewCell", bundle: nil)
    usersTableView.register(nib, forCellReuseIdentifier: "loginUserCell")
    usersTableView.backgroundView = nil
    usersTableView.backgroundColor = .clear
  }

  func fill(with user: FakeUser) {
    userNameField.text = user.id
    passwordField.text = user.password
    avatarView.kf.setImage(with: user.avatarURL)

    updatePlaceHoldersHiddenStates()
  }

  @IBAction func loginButtonTapped(_ sender: UIButton) {
    resignKeyboard()

    guard let userName = userNameField.text else {
      view.mbp.blink(title: "Need user name")
      userNameField.becomeFirstResponder()
      return
    }

    guard let password = passwordField.text else {
      view.mbp.blink(title: "Need password")
      passwordField.becomeFirstResponder()
      return
    }

    // simulate server logic

    guard
      let user = FakeUser.all[userName],
      user.password == password
      else {
        view.mbp.blink(title: "Invalid user name or password")
        return
    }
    
    FakeUser.current = user
    The.mainWindow.rootViewController = StoryboardScene.Main.initialScene.instantiate()
  }

}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

  func resignKeyboard() {
    userNameField.resignFirstResponder()
    passwordField.resignFirstResponder()
  }

  func updatePlaceHoldersHiddenStates() {
    userNamePlaceHolder.isHidden = userNameField.isFirstResponder || !(userNameField.text ?? "").isEmpty
    passwordPlaceholder.isHidden = passwordField.isFirstResponder || !(passwordField.text ?? "").isEmpty
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    updatePlaceHoldersHiddenStates()
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    updatePlaceHoldersHiddenStates()
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == userNameField {
      passwordField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }

    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    updatePlaceHoldersHiddenStates()
  }

}

// MARK: - UITableViewDelegate
extension LoginViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return FakeUser.all.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "loginUserCell", for: indexPath) as! LoginUserTableViewCell
    let user = loginUsers[indexPath.row]
    cell.avatarView.kf.setImage(with: user.avatarURL)
    cell.userNameField.text = user.fullName
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let user = loginUsers[indexPath.row]
    fill(with: user)
  }
}

