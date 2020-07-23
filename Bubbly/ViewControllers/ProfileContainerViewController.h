//
//  ProfileContainerViewController.h
//  Bubbly
//
//  Created by Fiona Barry on 7/23/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileContainerViewController : UIViewController

@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
