//
//  FriendTableViewCell.swift
//  LearnRY
//
//  Created by Mudox on 29/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
  
  var user: FakeUser!

  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    avatarView.layer.cornerRadius = 4
    avatarView.layer.masksToBounds = true
  }

  override func prepareForReuse() {
    avatarView.image = nil
    nameLabel.text = nil
  }
}
