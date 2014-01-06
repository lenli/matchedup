//
//  LLMatchesViewController.m
//  MatchedUp
//
//  Created by Len on 1/5/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLMatchesViewController.h"
#import "LLChatViewController.h"

@interface LLMatchesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *availableChatrooms;
@end

@implementation LLMatchesViewController

#pragma mark - Lazy Instantiation
-(NSMutableArray *)availableChatrooms
{
    if (!_availableChatrooms) {
        _availableChatrooms = [[NSMutableArray alloc] init];
    }
    return _availableChatrooms;
}

#pragma mark - MatchesViewController
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self updateAvailableChatrooms];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LLChatViewController *chatVC = segue.destinationViewController;
    NSIndexPath *indexPath = sender;
    chatVC.chatroom = [self.availableChatrooms objectAtIndex:indexPath.row];
    
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.availableChatrooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFObject *chatroom = [self.availableChatrooms objectAtIndex:indexPath.row];
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *textUser1 = chatroom[@"user1"];
    if ([textUser1.objectId isEqual:currentUser.objectId]) {
        likedUser = [chatroom objectForKey:@"user2"];
    } else {
        likedUser = [chatroom objectForKey:@"user1"];
    }
    
    cell.textLabel.text = likedUser[@"profile"][@"firstName"];

    // cell.imageView.image = placeholder image
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:@"Photo"];
    [queryForPhoto whereKey:@"user" equalTo:likedUser];
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kLLPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }];
        }
    }];
    
    
    return cell;
}
#pragma mark - UITableView Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
}

#pragma mark - Helper Methods
- (void)updateAvailableChatrooms
{
    PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
    [query whereKey:@"user1" equalTo:[PFUser currentUser]];
    
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"Chatroom"];
    [query whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    
    [queryCombined includeKey:@"chat"];
    [queryCombined includeKey:@"user1"];
    [queryCombined includeKey:@"user2"];
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatrooms removeAllObjects];
            self.availableChatrooms = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
    
}

@end
