//
//  ProfileViewController.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ProfileContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileTapGestureDelegate <NSObject>

- (void)didTapCloseSidebar;

@end

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) id<ProfileTapGestureDelegate>delegate;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) ProfileContainerViewController *profileContainerViewController;

@end

NS_ASSUME_NONNULL_END
