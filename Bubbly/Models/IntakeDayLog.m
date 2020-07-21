//
//  IntakeDayLog.m
//  Bubbly
//
//  Created by Fiona Barry on 7/21/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "IntakeDayLog.h"

@implementation IntakeDayLog

@dynamic user;
@dynamic logChanges;
@dynamic goal;
@dynamic achieved;

+ (nonnull NSString *)parseClassName {
    return @"IntakeDayLog";
}

@end
