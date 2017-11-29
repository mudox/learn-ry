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

  var contacts: [FakeUser]!

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1 // currently only friends
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return contacts.count
    default:
      return 0
    }
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
    let user = contacts[indexPath.row]
    cell.avatarView.kf.setImage(with: user.avatarURL, placeholder: #imageLiteral(resourceName: "PictureFile.png"))
    return cell
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    assert(segue.identifier == "showContactInfo", "only support `showContactInfo`")
    let destVC = segue.destination as! ContactInfoViewController
    let indexPath = tableView.indexPathForSelectedRow!
    let contact = contacts[indexPath.row]
    destVC.contact = contact
  }

}
