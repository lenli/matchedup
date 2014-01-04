//
//  LLSecondViewController.m
//  MatchedUp
//
//  Created by Leonard Li on 1/3/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLSecondViewController.h"

@interface LLSecondViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@end

@implementation LLSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    PFQuery *query = [PFQuery queryWithClassName:kLLPhotoClassKey];
    [query whereKey:kLLPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kLLPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.profilePictureImageView.image = [UIImage imageWithData:data];
            }];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
