//
//  ChatViewController.swift
//  LearnRY
//
//  Created by Mudox on 30/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import UIKit

class ChatViewController: RCConversationViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      
    tabBarController?.tabBar.isHidden = true
  }

}
