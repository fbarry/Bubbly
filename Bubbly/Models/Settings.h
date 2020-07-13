//
//  Settings.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : PFObject <PFSubclassing>

@property (strong, nonatomic) PFFileObject *backgroundPicture;
@property (strong, nonatomic) NSArray *logAmounts;

@end

NS_ASSUME_NONNULL_END
