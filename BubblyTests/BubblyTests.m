//
//  BubblyTests.m
//  BubblyTests
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HomeViewController.h"

@interface HomeViewController : XCTestCase

@end

@interface HomeViewController (UnitTest)

@property (strong, nonatomic) IntakeDayLog *dayLog;
@property (strong, nonatomic) User *user;

- (void)createNewLog;

@end

@implementation HomeViewController

HomeViewController *homeVC;

- (void)setUp {
    homeVC = [[HomeViewController alloc] init];
    homeVC.user = [User new];
}

- (void)tearDown {
    
}

- (void)testCreateNewLog {
    for (int i = 1; i <= 1000; i++) {
        for (int j = 1; j <= 1000; j++) {
            homeVC.user.weight = [NSNumber numberWithInt:i];
            homeVC.user.exercise = [NSNumber numberWithInt:j];
            [homeVC createNewLog];
            XCTAssertEqual(homeVC.dayLog.achieved.intValue, 0);
            XCTAssertEqual(homeVC.dayLog.goal.intValue, (int)(homeVC.user.weight.floatValue * 2.0 / 3.0 + 12.0 * homeVC.user.exercise.floatValue / 30.0));
        }
    }
}

@end
