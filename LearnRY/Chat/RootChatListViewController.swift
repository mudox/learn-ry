//
//  RootChatListViewController.swift
//  LearnRY
//
//  Created by Mudox on 29/11/2017.
//  Copyright © 2017 Mudox. All rights reserved.
//

import UIKit
import JacKit

fileprivate let jack = Jack.with(levelOfThisFile: .debug)

class RootChatListViewController: RCConversationListViewController {

  override func awakeFromNib() {
    super.awakeFromNib()

    configure()
  }

//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    // Do any additional setup after loading the view.
//  }

  func configure() {
    setDisplayConversationTypes([
      RCConversationType.ConversationType_PRIVATE,
      RCConversationType.ConversationType_GROUP,
      RCConversationType.ConversationType_DISCUSSION,
      RCConversationType.ConversationType_SYSTEM,
    ])

    setCollectionConversationType([
      RCConversationType.ConversationType_GROUP,
      RCConversationType.ConversationType_DISCUSSION,
    ])
  }

  override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
    switch conversationModelType {
      
    case .CONVERSATION_MODEL_TYPE_NORMAL:
      let vc = RCConversationViewController()
      vc.conversationType = model.conversationType
      vc.targetId = model.targetId
      vc.navigationItem.title = model.conversationTitle
      self.show(vc, sender: self)
      
    case .CONVERSATION_MODEL_TYPE_COLLECTION:
      break
    case .CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE:
      jack.warn("model type for `.CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE` is not implemented yet")
    case .CONVERSATION_MODEL_TYPE_CUSTOMIZATION:
      jack.warn("model type for `.CONVERSATION_MODEL_TYPE_CUSTOMIZATION` is not implemented yet")
    }
  }
}
