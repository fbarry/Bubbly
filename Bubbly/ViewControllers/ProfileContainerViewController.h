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

@protocol SidebarStatusDelegate <NSObject>

- (void)didOpenSidebar:(BOOL)status;

@end

@interface ProfileContainerViewController : UIViewController

@property (strong, nonatomic) id<SidebarStatusDelegate>delegate;
@property (strong, nonatomic) User *user;

- (IBAction)didTapSidebar:(id)sender;

@end

NS_ASSUME_NONNULL_END
