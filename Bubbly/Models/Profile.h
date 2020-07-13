//
//  Profile.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Profile : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) PFFileObject *profilePicture;
@property (strong, nonatomic) NSString *bio;

@end

NS_ASSUME_NONNULL_END
