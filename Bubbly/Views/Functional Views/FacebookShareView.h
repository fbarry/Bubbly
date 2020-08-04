//
//  FacebookShareView.h
//  Bubbly
//
//  Created by Fiona Barry on 7/27/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit.h>
#import <FBSDKLoginKit.h>
#import <FBSDKShareKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacebookShareView : UIView <FBSDKSharingDelegate>

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSString *title;

- (instancetype)initWithTitle:(NSString *)title photo:(UIImage *)photo caption:(NSString *)caption inViewController:(UIViewController *)viewController;
- (void)presentShareView;
- (void)createPost;

@end

NS_ASSUME_NONNULL_END
