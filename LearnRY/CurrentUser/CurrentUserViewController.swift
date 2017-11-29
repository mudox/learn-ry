//
//  RandomUserViewController.swift
//  RandomUser_Example
//
//  Created by Mudox on 15/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Eureka
import Kingfisher
import FlagKit
import iOSKit

class CurrentUserViewController: FormViewController {

  var user: FakeUser! {
    didSet {
      let values: [String: String] = [
        // basic info
        "Name": user.fullName,
        "Gender": user.gender == .male ? "Male" : "Female",
        "Birthday": user.birthday,
        // address
        "State": user.state,
        "City": user.city,
        "Street": user.street,
        // credential
        "User ID": user.id,
        "Password": user.password,
        // contact
        "Email": user.email,
        "Phone": user.phone,
      ]
      form.setValues(values)

      avatarView?.imageView.kf.setImage(with: user.avatarURL)
      avatarView?.flagView.image = Flag(countryCode: user.countryCode)?.image(style: .roundedRect)
    }
  }

  weak var avatarView: AvatarView? {
    return tableView.tableHeaderView as? AvatarView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initForm()
    user = FakeUser.current

  }

  func initForm() {
    let nib = UINib(nibName: "AvatarView", bundle: nil)
    let headerView = nib.instantiate(withOwner: nil, options: nil).first as! AvatarView
    tableView.tableHeaderView = headerView

    let basicSection = Section("Basic Infomation")
    for tag in ["Name", "Gender", "Birthday"] {
      basicSection <<< TextRow(tag) { row in
        row.title = row.tag
      }.cellUpdate { cell, row in
        cell.textField?.isEnabled = false
      }
    }

    let addressSection = Section("Address")
    for tag in ["State", "City", "Street"] {
      addressSection <<< TextRow(tag) { row in
        row.title = row.tag
      }.cellUpdate { cell, row in
        cell.textField?.isEnabled = false
      }
    }

    let credentialSection = Section("Credential")
    for tag in ["User ID", "Password"] {
      credentialSection <<< TextRow(tag) { row in
        row.title = row.tag
      }.cellUpdate { cell, row in
        cell.textField?.isEnabled = false
      }
    }

    let contactSection = Section("Contact")
    for tag in ["Email", "Phone"] {
      contactSection <<< TextRow(tag) { row in
        row.title = row.tag
      }.cellUpdate { cell, row in
        cell.textField?.isEnabled = false
      }
    }

    let logoutSection = Section()
    logoutSection <<< ButtonRow() {
      $0.title = "Logout"
    }.cellUpdate { cell, row in
      cell.backgroundColor = .red
      cell.textLabel?.textColor = .white
      cell.detailTextLabel?.textColor = .white
    }.onCellSelection { cell, row in
      The.appDelegate.logout()
    }

    form += [
      basicSection,
      addressSection,
      credentialSection,
      contactSection,
      logoutSection
    ]

  }
}
