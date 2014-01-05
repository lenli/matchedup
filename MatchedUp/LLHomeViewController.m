//
//  LLHomeViewController.m
//  MatchedUp
//
//  Created by Len on 1/4/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLHomeViewController.h"

@interface LLHomeViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *taglineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;

@end

@implementation LLHomeViewController

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
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kLLPhotoClassKey];
    [query includeKey:kLLPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.photos = objects;
        if (!error) {
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
        } else {
            NSLog(@"Error downloading photos: %@", error);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
}
- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender
{
}
- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkPhoto:YES];
}
- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkPhoto:NO];
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
}

#pragma mark - Helper Methods
- (void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kLLPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }
            else NSLog(@"Error getting current photo: %@",error);
        }];
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kLLActivityClassKey];
        [queryForLike whereKey:kLLActivityTypeKey equalTo:kLLActivityTypeLikeKey];
        [queryForLike whereKey:kLLActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kLLActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kLLActivityClassKey];
        [queryForDislike whereKey:kLLActivityTypeKey equalTo:kLLActivityTypeDislikeKey];
        [queryForDislike whereKey:kLLActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kLLActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForLikeAndDislike = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [queryForLikeAndDislike findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.activities = [objects mutableCopy];
                if ([self.activities count] == 0) {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                } else {
                    PFObject *activity = self.activities[0];
                    if ([activity[kLLActivityTypeKey] isEqualToString:kLLActivityTypeLikeKey]) {
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    } else if ([activity[kLLActivityTypeKey] isEqualToString:kLLActivityTypeDislikeKey]) {
                        self.isDislikedByCurrentUser = YES;
                        self.isLikedByCurrentUser = NO;
                    }
                }
                self.likeButton.enabled = YES;
                self.dislikeButton.enabled = YES;
            }
        }];
    }
}

- (void)updateView
{
    self.firstNameLabel.text = self.photo[kLLPhotoUserKey][kLLUserProfileKey][kLLUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[kLLPhotoUserKey][kLLUserProfileKey][kLLUserProfileAgeKey]];
    self.taglineLabel.text = self.photo[kLLPhotoUserKey][kLLUserTaglineKey];
    
}

- (void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 < self.photos.count) {
        self.currentPhotoIndex ++;
        [self queryForCurrentPhotoIndex];
    } else {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"No More Users" message:@"Check back later for more people!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertview show];
    }
}

- (void)saveLikeActivity:(BOOL)isLiked
{
    PFObject *activity = [PFObject objectWithClassName:kLLActivityClassKey];
    
    if (isLiked) {
        [activity setObject:kLLActivityTypeLikeKey forKey:kLLActivityTypeKey];
    } else {
        [activity setObject:kLLActivityTypeDislikeKey forKey:kLLActivityTypeKey];
    }

    [activity setObject:[PFUser currentUser] forKey:kLLActivityFromUserKey];
    [activity setObject:[self.photo objectForKey:kLLPhotoUserKey] forKey:kLLActivityToUserKey];
    [activity setObject:self.photo forKey:kLLActivityPhotoKey];
    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        self.isLikedByCurrentUser = isLiked;
        self.isDislikedByCurrentUser = !isLiked;
        [self.activities addObject:activity];
        NSLog(@"%@", activity);
        [self setupNextPhoto];
    }];
}

- (void)checkPhoto:(BOOL)isLiked
{
    if (self.isLikedByCurrentUser == isLiked) {
        [self setupNextPhoto];
        return;
    } else if (self.isDislikedByCurrentUser == isLiked) {
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLikeActivity:isLiked];
    } else {
        [self saveLikeActivity:isLiked];
    }
}

@end







