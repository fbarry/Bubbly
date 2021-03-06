//
//  IntakeLog.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntakeLog : PFObject <PFSubclassing>

@property (strong, nonatomic) NSNumber *logAmount;

@end

NS_ASSUME_NONNULL_END
