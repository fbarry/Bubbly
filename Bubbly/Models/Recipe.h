//
//  Recipe.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Recipe : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *ingredients;
@property (strong, nonatomic) PFFileObject *picture;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) PFRelation *savedBy;
@property (strong, nonatomic) User *creator;

@end

NS_ASSUME_NONNULL_END
