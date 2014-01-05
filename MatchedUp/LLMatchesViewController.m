//
//  LLMatchesViewController.m
//  MatchedUp
//
//  Created by Len on 1/5/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLMatchesViewController.h"

@interface LLMatchesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tabelView;

@end

@implementation LLMatchesViewController

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

@end
