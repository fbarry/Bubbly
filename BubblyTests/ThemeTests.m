//
//  ThemeTests.m
//  BubblyTests
//
//  Created by Fiona Barry on 8/6/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SceneDelegate.h"
#import "Theme.h"

static const int numThemes = 4;

@interface ThemeTests : XCTestCase

@end

@interface SceneDelegate (UnitTest)

- (id<Theme>) getThemeByName:(ThemeName)name withColor:(int)color;

@end

@implementation ThemeTests

SceneDelegate *scene;

- (void)setUp {
    scene = [[SceneDelegate alloc] init];
}

- (void)tearDown {

}

- (void)testGetThemeByName {
    for (int i = 0; i < numThemes; i++) {
        XCTAssertNotNil([scene getThemeByName:i withColor:0]);
    }
}

@end
