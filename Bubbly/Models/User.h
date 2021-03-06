//
//  User.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileProtocol <NSObject>

@property (readonly) NSURL *profilePictureURL;
@property (readonly) NSString *name;
@property (readonly) NSString *profileUsername;

@end

@interface User : PFUser <ProfileProtocol>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) PFFileObject *profilePicture;
@property (strong, nonatomic) NSNumber *weight;
@property (strong, nonatomic) NSNumber *exercise;
@property (strong, nonatomic) PFFileObject *backgroundPicture;
@property (strong, nonatomic) NSArray *logAmounts;
@property (strong, nonatomic) PFRelation *savedRecipes;
@property (strong, nonatomic) NSNumber *FBConnected;
@property (strong, nonatomic) NSNumber *weatherEnabled;
@property (strong, nonatomic) NSNumber *notificationsEnabled;
@property (strong, nonatomic) NSNumber *notifictionTimeInterval;
@property (strong, nonatomic) NSNumber *theme;
@property (strong, nonatomic) NSNumber *color;

- (User *)copyUser;
- (BOOL)compareTo:(User *)user;

@end

NS_ASSUME_NONNULL_END
