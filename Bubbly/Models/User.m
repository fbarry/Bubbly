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
@dynamic weight;
@dynamic exercise;
@dynamic backgroundPicture;
@dynamic logAmounts;
@dynamic savedRecipes;
@dynamic FBConnected;
@dynamic weatherEnabled;
@dynamic notificationsEnabled;
@dynamic notifictionTimeInterval;
@dynamic theme;

- (NSURL *)profilePictureURL {
    return [NSURL URLWithString:self.profilePicture.url];
}

- (NSString *)profileUsername {
    return [NSString stringWithFormat:@"@%@", self.username];
}

- (User *)copyUser {
    User *user = [User new];
    user.name = self.name;
    user.username = self.username;
    user.email = self.email;
    user.profilePicture = self.profilePicture;
    user.weight = self.weight;
    user.exercise = self.exercise;
    user.backgroundPicture = self.backgroundPicture;
    user.logAmounts = self.logAmounts;
    user.FBConnected = self.FBConnected;
    user.weatherEnabled = self.weatherEnabled;
    user.notificationsEnabled = self.notificationsEnabled;
    user.notifictionTimeInterval = self.notifictionTimeInterval;
    user.theme = self.theme;
    user.color = self.color;
    return user;
}

- (BOOL)compareTo:(User *)user {    
    if (![user.name isEqualToString:self.name]) {
        return NO;
    } else if (![user.username isEqualToString:self.username]) {
        return NO;
    } if (![user.email isEqualToString:self.email]) {
        return NO;
    } else if (user.profilePicture && ![user.profilePicture.url isEqualToString:self.profilePicture.url]) {
        return NO;
    } else if (![user.weight isEqualToNumber:self.weight]) {
        return NO;
    } else if (![user.exercise isEqualToNumber:self.exercise]) {
        return NO;
    } else if (user.backgroundPicture && ![user.backgroundPicture isEqual:self.backgroundPicture]) {
        return NO;
    } else if (![user.logAmounts isEqualToArray:self.logAmounts]) {
        return NO;
    } else if (![user.FBConnected isEqualToNumber:self.FBConnected]) {
        return NO;
    } else if (![user.weatherEnabled isEqualToNumber:self.weatherEnabled]) {
        return NO;
    } else if (![user.notificationsEnabled isEqualToNumber:self.notificationsEnabled]) {
        return NO;
    } else if (![user.notifictionTimeInterval isEqualToNumber:self.notifictionTimeInterval]) {
        return NO;
    } else if (![user.theme isEqualToNumber:self.theme]) {
        return NO;
    } else if (user.color.intValue != self.color.intValue) {
        return NO;
    } else {
        return YES;
    }
}

@end
