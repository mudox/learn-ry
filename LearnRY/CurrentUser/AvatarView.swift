//
//  AvatarView.swift
//  RandomUser_Example
//
//  Created by Mudox on 15/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class AvatarView: UIView {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var flagView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    
    imageView.layer.cornerRadius = imageView.bounds.height / 2
    imageView.layer.masksToBounds = true
    imageView.backgroundColor = .lightGray
  }
}
