//
//  Recipe.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

@dynamic ingredients;
@dynamic name;
@dynamic picture;
@dynamic descriptionText;
@dynamic url;
@dynamic savedBy;
@dynamic creator;

+ (nonnull NSString *)parseClassName {
    return @"Recipe";
}

@end
