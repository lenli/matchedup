//
//  LLHomeViewController.m
//  MatchedUp
//
//  Created by Len on 1/4/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLHomeViewController.h"
#import "LLTestUser.h"
#import "LLProfileViewController.h"
#import "LLMatchViewController.h"

@interface LLHomeViewController () <LLMatchViewControllerDelegate>

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
//    [LLTestUser saveTestUserToParse];
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kLLPhotoClassKey];
    [query whereKey:kLLPhotoUserKey notEqualTo:[PFUser currentUser]];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"]) {
        LLProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
        
    } else if ([segue.identifier isEqualToString:@"homeToMatchSegue"]) {
        LLMatchViewController *matchVC = segue.destinationViewController;
        matchVC.matchedUserImage = self.photoImageView.image;
        matchVC.delegate = self;
    }
}

#pragma mark - IBActions
- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
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
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
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
                self.infoButton.enabled = YES;
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
    
    [activity setObject:isLiked ? kLLActivityTypeLikeKey : kLLActivityTypeDislikeKey forKey:kLLActivityTypeKey];

    [activity setObject:[PFUser currentUser] forKey:kLLActivityFromUserKey];
    [activity setObject:[self.photo objectForKey:kLLPhotoUserKey] forKey:kLLActivityToUserKey];
    [activity setObject:self.photo forKey:kLLActivityPhotoKey];
    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = isLiked;
        self.isDislikedByCurrentUser = !isLiked;
        [self.activities addObject:activity];
        if (isLiked) [self checkForPhotoUserLikes];
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

- (void)checkForPhotoUserLikes
{
    NSLog(@"Checking for PhotoUserLikes");
    PFQuery *query = [PFQuery queryWithClassName:kLLActivityClassKey];
    [query whereKey:kLLActivityFromUserKey equalTo:self.photo[kLLPhotoUserKey]];
    [query whereKey:kLLActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kLLActivityTypeKey equalTo:kLLActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            [self createChatroom];
        }
    }];
    
}

- (void)createChatroom
{
    NSLog(@"Creating Chatroom");
    PFQuery *queryForChatroom = [PFQuery queryWithClassName:@"Chatroom"];
    [queryForChatroom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatroom whereKey:@"user2" equalTo:self.photo[kLLPhotoUserKey]];
    
    PFQuery *queryForChatroomInverse = [PFQuery queryWithClassName:@"Chatroom"];
    [queryForChatroomInverse whereKey:@"user1" equalTo:self.photo[kLLPhotoUserKey]];
    [queryForChatroomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *queryChatroom = [PFQuery orQueryWithSubqueries:@[queryForChatroom, queryForChatroomInverse]];
    [queryChatroom findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            PFObject *chatroom = [PFObject objectWithClassName:@"Chatroom"];
            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatroom setObject:self.photo[kLLPhotoUserKey] forKey:@"user2"];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
            }];
            
        }
    }];
    
}

#pragma mark - LLMatchViewController Delegate Methods
- (void)presentMatchesViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
}
@end







