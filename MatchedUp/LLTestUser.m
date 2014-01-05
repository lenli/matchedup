//
//  LLTestUser.m
//  MatchedUp
//
//  Created by Len on 1/4/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLTestUser.h"

@implementation LLTestUser

+(void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"testuser";
    newUser.password = @"password";
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSDictionary *profile = @{@"age" : @28,
                                      @"birthday" : @"11/11/1985",
                                      @"firstName" : @"Julie",
                                      @"gender" : @"female",
                                      @"location" : @"Berlin, Germany",
                                      @"name" : @"Julie Adams"
                                      };
            NSLog(@"%@",profile);
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"Spider_robot.png"];
                NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile = [PFFile fileWithData:imageData];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        PFObject *photo = [PFObject objectWithClassName:kLLPhotoClassKey];
                        [photo setObject:newUser forKey:kLLPhotoUserKey];
                        [photo setObject:photoFile forKey:kLLPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
    
}
@end
