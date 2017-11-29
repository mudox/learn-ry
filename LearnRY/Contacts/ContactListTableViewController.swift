//
//  ContactListTableViewController.swift
//  LearnRY
//
//  Created by Mudox on 28/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import UIKit
import Kingfisher

class ContactListTableViewController: UITableViewController {

  class CellModel {
    init(title: String, imageURL: URL) {
      self.title = title
      self.imageURL = imageURL
    }

    let imageURL: URL
    let title: String
  }

  class FriendCellModel: CellModel {
    init(user: FakeUser) {
      self.user = user
      super.init(
        title: user.fullName,
        imageURL: user.avatarURL
      )
    }

    let user: FakeUser
  }

  class GroupCellModel: CellModel {
    // TODO: implement it
  }

  var tableViewModel: [(sectionTitle: String, cellModels: [CellModel])]!

  func set(contacts: [FakeUser]) {
    var dict = [String: [CellModel]]()
    for user in contacts {
      let initial = String(user.firstName.first!)
      let model = FriendCellModel(user: user)
      dict[initial] = dict[initial] ?? [CellModel]()
      dict[initial]!.append(model)
    }
    tableViewModel = dict.map { (sectionTitle: $0, cellModels: $1) }
  }

  func model(forRowAt indexPath: IndexPath) -> CellModel {
    return tableViewModel[indexPath.section].cellModels[indexPath.row]
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let contacts = FakeUser.current.friends.map { FakeUser.all[$0]! }
    set(contacts: contacts)
  }


  // MARK: - UITableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return tableViewModel.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewModel[section].cellModels.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellModel = model(forRowAt: indexPath)
    switch cellModel {

    case is FriendCellModel:
      let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
      cell.avatarView.kf.setImage(with: cellModel.imageURL, placeholder: UIImage(asset: Asset.contactSquare))
      cell.nameLabel.text = cellModel.title
      return cell

    default:
      assertionFailure()
      return UITableViewCell()
    }
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return tableViewModel[section].sectionTitle
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cellModel = model(forRowAt: indexPath)
    switch cellModel {
      
    case let model as FriendCellModel:
      let vc = StoryboardScene.Contacts.contactInfoViewController.instantiate()
      vc.contact = model.user
      
    default:
      assertionFailure()
    }
  }

//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    assert(segue.identifier == "showContactInfo", "only support `showContactInfo`")
//    let destVC = segue.destination as! ContactInfoViewController
//    let indexPath = tableView.indexPathForSelectedRow!
//    let contact = tableViewModel[indexPath.section].cellModels[indexPath.row]
//    destVC.contact = contact
//  }

}
