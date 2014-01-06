//
//  LLMatchViewController.h
//  MatchedUp
//
//  Created by Len on 1/5/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLMatchViewControllerDelegate <NSObject>

-(void)presentMatchesViewController;

@end

@interface LLMatchViewController : UIViewController
@property (strong,nonatomic) UIImage *matchedUserImage;
@property (weak) id <LLMatchViewControllerDelegate> delegate;

@end
