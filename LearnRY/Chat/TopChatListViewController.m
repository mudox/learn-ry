//
// TopChatListViewController.m
// LearnRY
//
// Created by Mudox on 13/11/2017.
// Copyright © 2017 Mudox. All rights reserved.
//

#import "TopChatListViewController.h"
#import "SecondaryChatListViewController.h"

@interface TopChatListViewController ()

@end

@implementation TopChatListViewController

- (instancetype)init
{
  if (nil == (self = [super init]))
  {
    return nil;
  }

  [self configure];

  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self configure];
}


- (void)configure
{
  [self setDisplayConversationTypes:@[
     @(ConversationType_PRIVATE),
     @(ConversationType_DISCUSSION),
     @(ConversationType_CHATROOM),
     @(ConversationType_GROUP),
     @(ConversationType_APPSERVICE),
     @(ConversationType_SYSTEM)
   ]];

  [self setCollectionConversationType:@[
     @(ConversationType_DISCUSSION),
     @(ConversationType_GROUP)
   ]];
}


- (void)onSelectedTableRow: (RCConversationModelType)conversationModelType
         conversationModel: (RCConversationModel *)model
               atIndexPath: (NSIndexPath *)indexPath
{
  switch (conversationModelType)
  {
  case RC_CONVERSATION_MODEL_TYPE_COLLECTION:
  {
    SecondaryChatListViewController *vc = [[SecondaryChatListViewController alloc] initWithConversationType:model.conversationType];
    vc.navigationItem.title = model.conversationTitle;
    [self showViewController:vc sender:self];
  }
  break;

  case RC_CONVERSATION_MODEL_TYPE_NORMAL:
  {
    RCConversationViewController *vc = [RCConversationViewController new];
    vc.conversationType     = model.conversationType;
    vc.targetId             = model.targetId;
    vc.navigationItem.title = model.conversationTitle;
    [self showViewController:vc sender:self];
  }
  break;

  default:
    break;
  }

}

@end




