//
// SecondaryChatListViewController.m
// LearnRY
//
// Created by Mudox on 13/11/2017.
// Copyright © 2017 Mudox. All rights reserved.
//

#import "SecondaryChatListViewController.h"

@interface SecondaryChatListViewController ()

@end

@implementation SecondaryChatListViewController

- (instancetype)initWithConversationType: (RCConversationType)type
{
  if (nil == (self = [super init]))
  {
    return nil;
  }

  self.isEnteredToCollectionViewController = YES;
  [self setDisplayConversationTypes:@[@(type)]];
  [self setCollectionConversationType:nil];

  return self;
}

// - (void)viewDidLoad
// {
// [super viewDidLoad];
//
// }

- (void)onSelectedTableRow: (RCConversationModelType)conversationModelType
         conversationModel: (RCConversationModel *)model
               atIndexPath: (NSIndexPath *)indexPath
{

  RCConversationViewController *vc = [RCConversationViewController new];
  vc.conversationType     = model.conversationType;
  vc.targetId             = model.targetId;
  vc.navigationItem.title = model.conversationTitle;
  [self showViewController:vc sender:self];

}

@end





