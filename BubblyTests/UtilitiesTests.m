//
//  UtilitiesTests.m
//  BubblyTests
//
//  Created by Fiona Barry on 8/4/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utilities.h"

@interface UtilitiesTests : XCTestCase

@end

@implementation UtilitiesTests

- (void)setUp {
    
}

- (void)tearDown {

}

- (void)testResizeImage {
    UIImage *image = [UIImage imageNamed:@"logo-icon"];
    UIImage *resized = [Utilities resizeImage:image withSize:CGSizeMake(100, 100)];
    XCTAssertEqual(resized.size.width, 100);
    XCTAssertEqual(resized.size.height, 100);
}

@end
