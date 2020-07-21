//
//  IntakeDayLog.h
//  Bubbly
//
//  Created by Fiona Barry on 7/21/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntakeDayLog : PFObject <PFSubclassing>

@property (strong, nonatomic) NSNumber *goal;
@property (strong, nonatomic) NSNumber *achieved;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) PFRelation *logChanges;

@end

NS_ASSUME_NONNULL_END
