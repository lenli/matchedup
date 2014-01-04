//
//  LLEditProfileViewController.m
//  MatchedUp
//
//  Created by Len on 1/4/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLEditProfileViewController.h"

@interface LLEditProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextView *taglineTextView;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;

@end

@implementation LLEditProfileViewController

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
- (IBAction)saveBarButtonItemPressed:(UIBarButtonItem *)sender
{
}



@end