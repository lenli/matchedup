//
//  LLChatViewController.h
//  MatchedUp
//
//  Created by Leonard Li on 1/5/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface LLChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>
@property (strong, nonatomic) PFObject *chatroom;

@end
