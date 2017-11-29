//
// SecondaryChatListViewController.h
// LearnRY
//
// Created by Mudox on 13/11/2017.
// Copyright © 2017 Mudox. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface SecondaryChatListViewController : RCConversationListViewController

- (instancetype)initWithConversationType: (RCConversationType)type;

@end

