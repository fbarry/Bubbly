//
//  UserTests.m
//  BubblyTests
//
//  Created by Fiona Barry on 8/4/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"
#import "Utilities.h"

@interface UserTests : XCTestCase

@end

@implementation UserTests

User *user, *copyUser;

- (void)setUp {
    user = [User new];
    user.name = @"First Last";
    user.username = @"username";
    user.email = @"email@email.com";
    user.profilePicture = [Utilities getPFFileFromImage:[UIImage imageNamed:@"logo-icon"]];
    user.weight = [NSNumber numberWithInt:120];
    user.exercise = [NSNumber numberWithInt:120];
    user.backgroundPicture = [Utilities getPFFileFromImage:[UIImage imageNamed:@"bottle"]];
    user.logAmounts = @[@"1", @"3", @"7", @"9"];
    user.FBConnected = [NSNumber numberWithInt:0];
    user.weatherEnabled = [NSNumber numberWithInt:1];
    user.notificationsEnabled = [NSNumber numberWithInt:1];
    user.notifictionTimeInterval = [NSNumber numberWithInt:60];
    user.theme = [NSNumber numberWithInt:2];
    user.color = [NSNumber numberWithInt:1];
}

- (void)tearDown {
    
}

- (void)testCopyUser {
    copyUser = [user copyUser];
    XCTAssertTrue([user copyUser]);
}

- (void)testCompareUser {
    // User profile picture and background picture are NOT included
    // These changes are recorded in the CameraViewDelegate method of settings
    
    copyUser = [User new];
    copyUser.name = @"First Last";
    copyUser.username = @"username";
    copyUser.email = @"email@email.com";
    copyUser.weight = [NSNumber numberWithInt:120];
    copyUser.exercise = [NSNumber numberWithInt:120];
    copyUser.logAmounts = @[@"1", @"3", @"7", @"9"];
    copyUser.FBConnected = [NSNumber numberWithInt:0];
    copyUser.weatherEnabled = [NSNumber numberWithInt:1];
    copyUser.notificationsEnabled = [NSNumber numberWithInt:1];
    copyUser.notifictionTimeInterval = [NSNumber numberWithInt:60];
    copyUser.theme = [NSNumber numberWithInt:2];
    copyUser.color = [NSNumber numberWithInt:1];
    
    XCTAssertTrue([user compareTo:copyUser]);
}

@end
