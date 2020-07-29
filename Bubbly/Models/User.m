//
//  User.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic name;
@dynamic profilePicture;
@dynamic bio;
@dynamic weight;
@dynamic exercise;
@dynamic backgroundPicture;
@dynamic logAmounts;
@dynamic savedRecipes;
@dynamic FBConnected;
@dynamic weatherEnabled;
@dynamic notificationsEnabled;
@dynamic notifictionTimeInterval;
@dynamic notificationBegin;
@dynamic notificatonEnd;

- (NSURL *)profilePictureURL {
    return [NSURL URLWithString:self.profilePicture.url];
}

- (NSString *)profileUsername {
    return [NSString stringWithFormat:@"@%@", self.username];
}

@end
