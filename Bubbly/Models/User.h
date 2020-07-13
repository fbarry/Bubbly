//
//  User.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>
#import "Profile.h"
#import "Health.h"
#import "Settings.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser

@property (strong, nonatomic) Profile *profile;
@property (strong, nonatomic) Health *health;
@property (strong, nonatomic) Settings *settings;

@end

NS_ASSUME_NONNULL_END
