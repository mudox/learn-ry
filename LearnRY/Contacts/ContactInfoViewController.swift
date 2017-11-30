//
//  ContactInfoViewController.swift
//  LearnRY
//
//  Created by Mudox on 28/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//


import UIKit
import Eureka
import Kingfisher
import FlagKit
import iOSKit

class ContactInfoViewController: FormViewController {

  var contact: FakeUser!

  func reloadData() {
    let values: [String: String] = [
      // basic info
      "Name": contact.fullName,
      "Gender": contact.gender == .male ? "Male" : "Female",
      "Birthday": contact.birthday,
      // address
      "State": contact.state,
      "City": contact.city,
      "Street": contact.street,
      // credential
      "User ID": contact.id,
      "Password": contact.password,
      // contact
      "Email": contact.email,
      "Phone": contact.phone,
    ]

    form.setValues(values)
    tableView.reloadData()

    avatarView?.imageView.kf.setImage(with: contact.avatarURL)
    avatarView?.flagView.image = Flag(countryCode: contact.countryCode)?.image(style: .roundedRect)
  }

  weak var avatarView: AvatarView? {
    return tableView.tableHeaderView as? AvatarView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initForm()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    reloadData()
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

    let chatSection = Section()
    chatSection <<< ButtonRow() {
      $0.title = "Chat"
    }.cellUpdate { cell, row in
      cell.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      cell.textLabel?.textColor = .white
      cell.detailTextLabel?.textColor = .white
    }.onCellSelection { [unowned self] cell, row in
      self.navigationController?.popToRootViewController(animated: false)
      
      The.chatNavigationController.popToRootViewController(animated: false)
      let vc = ChatViewController(conversationType: .ConversationType_PRIVATE, targetId: self.contact.id)!
      The.chatNavigationController.pushViewController(vc, animated: true)
      
      The.rootTabBarController.selectedIndex = 0
    }

    form += [
      chatSection,
      
      basicSection,
      addressSection,
      credentialSection,
      contactSection,
    ]

  }
}

