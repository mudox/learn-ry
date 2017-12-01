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

  func configure() {
    
    navigationItem.title = "LearnRY"

    setDisplayConversationTypes([
      RCConversationType.ConversationType_PRIVATE.rawValue,
      RCConversationType.ConversationType_GROUP.rawValue,
      RCConversationType.ConversationType_DISCUSSION.rawValue,
      RCConversationType.ConversationType_SYSTEM.rawValue,
    ])

    setCollectionConversationType([
      RCConversationType.ConversationType_GROUP.rawValue,
      RCConversationType.ConversationType_DISCUSSION.rawValue,
    ])
  
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    conversationListTableView.separatorStyle = .none
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      
    tabBarController?.tabBar.isHidden = false
  }

  override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
    switch conversationModelType {
      
    case .CONVERSATION_MODEL_TYPE_NORMAL:
      let vc = ChatViewController(conversationType: model.conversationType, targetId: model.targetId)!
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
