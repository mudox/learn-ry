//
//  LoginUserTableViewCell.swift
//  LearnRY
//
//  Created by Mudox on 29/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import UIKit

class LoginUserTableViewCell: UITableViewCell {

  var user: FakeUser!

  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var userNameField: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    backgroundColor = .clear
    
    avatarView.layer.cornerRadius = avatarView.bounds.height / 2
    avatarView.layer.masksToBounds = true
  }
  
}
