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
#import <FBSDKSharing.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacebookShareView : UIView <FBSDKSharingDelegate>

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSString *title;

- (instancetype)initWithTitle:(NSString *)title photos:(NSArray *)photos inViewController:(UIViewController *)viewController;
- (void)presentShareView;
- (void)createPost;

@end

NS_ASSUME_NONNULL_END
