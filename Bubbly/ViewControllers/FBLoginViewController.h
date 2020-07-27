//
//  FBLoginViewController.h
//  Bubbly
//
//  Created by Fiona Barry on 7/27/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit.h>
#import <FBSDKLoginKit.h>
#import "FacebookShareView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FBLoginViewControllerDelegate <NSObject>

- (void)completedWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error inShareView:(FacebookShareView *)share;

@end

@interface FBLoginViewController : UIViewController

@property (strong, nonatomic) id<FBLoginViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (strong, nonatomic) FacebookShareView *shareView;

@end

NS_ASSUME_NONNULL_END
