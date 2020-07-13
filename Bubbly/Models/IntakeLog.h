//
//  IntakeLog.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntakeLog : PFObject <PFSubclassing>

@property (strong, nonatomic) NSNumber *goal;
@property (strong, nonatomic) NSNumber *achieved;

@end

NS_ASSUME_NONNULL_END
