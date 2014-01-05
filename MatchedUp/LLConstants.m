//
//  LLConstants.m
//  MatchedUp
//
//  Created by Leonard Li on 1/3/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import "LLConstants.h"

@implementation LLConstants

#pragma mark - User Class
NSString *const kLLUserTaglineKey               =@"tagline";

NSString *const kLLUserProfileKey               = @"profile";
NSString *const kLLUserProfileNameKey           = @"name";
NSString *const kLLUserProfileFirstNameKey      = @"firstName";
NSString *const kLLUserProfileLocationKey       = @"location";
NSString *const kLLUserProfileGenderKey         = @"gender";
NSString *const kLLUserProfileBirthdayKey       = @"birthday";
NSString *const kLLUserProfileInterestedInKey   = @"interestedIn";
NSString *const kLLUserProfilePictureURL        = @"PictureURL";
NSString *const kLLUserProfileRelationshipStatusKey =@"relationshipStatus";
NSString *const kLLUserProfileAgeKey            = @"age";

#pragma mark - Photo Class

NSString *const kLLPhotoClassKey                = @"Photo";
NSString *const kLLPhotoUserKey                 = @"user";
NSString *const kLLPhotoPictureKey              = @"image";


#pragma mark - Activity Class

NSString *const kLLActivityClassKey             = @"Activity";
NSString *const kLLActivityTypeKey              = @"type";
NSString *const kLLActivityFromUserKey          = @"fromUser";
NSString *const kLLActivityToUserKey            = @"toUser";
NSString *const kLLActivityPhotoKey             = @"photo";
NSString *const kLLActivityTypeLikeKey          = @"like";
NSString *const kLLActivityTypeDislikeKey       = @"dislike";

@end
