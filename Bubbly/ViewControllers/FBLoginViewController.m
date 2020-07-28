//
//  FBLoginViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/27/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "FBLoginViewController.h"

@interface FBLoginViewController () <FBSDKLoginButtonDelegate>

@end

@implementation FBLoginViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.delegate = self;
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(nonnull FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate completedWithResult:result error:error inShareView:self.shareView];
    }];
}

- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton {
    NSLog(@"didLogOut");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
