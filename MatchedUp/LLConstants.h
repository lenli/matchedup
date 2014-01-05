//
//  LLConstants.h
//  MatchedUp
//
//  Created by Leonard Li on 1/3/14.
//  Copyright (c) 2014 LL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLConstants : NSObject

#pragma mark - User Class

extern NSString *const kLLUserTaglineKey;

extern NSString *const kLLUserProfileKey;
extern NSString *const kLLUserProfileNameKey;
extern NSString *const kLLUserProfileFirstNameKey;
extern NSString *const kLLUserProfileLocationKey;
extern NSString *const kLLUserProfileGenderKey;
extern NSString *const kLLUserProfileBirthdayKey;
extern NSString *const kLLUserProfileInterestedInKey;
extern NSString *const kLLUserProfilePictureURL;
extern NSString *const kLLUserProfileRelationshipStatusKey;
extern NSString *const kLLUserProfileAgeKey;


#pragma mark - Photo Class
extern NSString *const kLLPhotoClassKey;
extern NSString *const kLLPhotoUserKey;
extern NSString *const kLLPhotoPictureKey;

#pragma mark - Activity Class
extern NSString *const kLLActivityClassKey;
extern NSString *const kLLActivityTypeKey;
extern NSString *const kLLActivityFromUserKey;
extern NSString *const kLLActivityToUserKey;
extern NSString *const kLLActivityPhotoKey;
extern NSString *const kLLActivityTypeLikeKey;
extern NSString *const kLLActivityTypeDislikeKey;

#pragma mark - Settings
extern NSString *const kLLMenEnabledKey;
extern NSString *const kLLWomenEnabledKey;
extern NSString *const kLLSingleEnabledKey;
extern NSString *const kLLAgeMaxKey;

@end