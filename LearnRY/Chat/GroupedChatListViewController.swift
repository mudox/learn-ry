//
//  GroupedChatListViewController.swift
//  LearnRY
//
//  Created by Mudox on 29/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import UIKit

class GroupedChatListViewController: RCConversationListViewController {

  override func awakeFromNib() {
    super.awakeFromNib()

    configure()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  func configure() {
    isEnteredToCollectionViewController = true
    setCollectionConversationType(nil)
  }

  override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
    let vc = RCConversationViewController()
    vc.conversationType = model.conversationType
    vc.targetId = model.targetId
    vc.navigationItem.title = model.conversationTitle
    self.show(vc, sender: self)
  }

}
