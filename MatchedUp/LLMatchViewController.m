//
//  LLMatchViewController.m
//  MatchedUp
//
//  Created by Len on 1/5/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLMatchViewController.h"

@interface LLMatchViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *matchedUserImageView;
@property (strong, nonatomic) IBOutlet UIImageView *currentUserImageView;
@property (strong, nonatomic) IBOutlet UIButton *chatViewButton;
@property (strong, nonatomic) IBOutlet UIButton *keepSearchingButton;

@end

@implementation LLMatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)viewChatsButtonPressed:(UIButton *)sender
{

}

- (IBAction)keepSearchingButtonPressed:(UIButton *)sender
{
    
}

@end
