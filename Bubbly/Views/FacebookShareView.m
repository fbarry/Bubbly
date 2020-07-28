//
//  FacebookShareView.m
//  Bubbly
//
//  Created by Fiona Barry on 7/27/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "FacebookShareView.h"
#import "Utilities.h"

@implementation FacebookShareView

- (instancetype)initWithTitle:(NSString *)title photos:(NSArray *)photos inViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _title = title;
        _photos = photos;
        _viewController = viewController;
    }
    return self;
}

- (void)presentShareView {
    [Utilities presentConfirmationInViewController:self.viewController
                                         withTitle:self.title
                                        yesHandler:^{
        if (![FBSDKAccessToken currentAccessToken]) {
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logInWithPermissions:@[@"public_profile"] fromViewController:self.viewController handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
                if (error) {
                    [Utilities presentOkAlertControllerInViewController:self.viewController
                                                              withTitle:error.userInfo[FBSDKErrorLocalizedTitleKey]
                                                                message:[NSString stringWithFormat:@"%@", error.userInfo[FBSDKErrorLocalizedDescriptionKey]]];
                } else {
                    [self createPost];
                }
            }];
        } else {
            [self createPost];
        }
    }];
}

- (void)createPost {
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = [UIImage systemImageNamed:@"Book"];
    photo.userGenerated = YES;
        
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
        
    [FBSDKShareDialog showFromViewController:self.viewController
                                 withContent:content
                                    delegate:self];
}

#pragma mark - FBSDKSharingDelegate

- (void)sharer:(nonnull id<FBSDKSharing>)sharer didCompleteWithResults:(nonnull NSDictionary<NSString *,id> *)results {
    NSLog(@"success");
}

- (void)sharer:(nonnull id<FBSDKSharing>)sharer didFailWithError:(nonnull NSError *)error {
    [Utilities presentOkAlertControllerInViewController:self.viewController
                                              withTitle:@"Could not share"
                                                message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
}

- (void)sharerDidCancel:(nonnull id<FBSDKSharing>)sharer {
    NSLog(@"cancel");
}

@end
