//
//  ProfileContainerViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/23/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "ProfileContainerViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"
#import "SavedViewController.h"
#import "SettingsViewController.h"
#import "BuyViewController.h"

@interface ProfileContainerViewController () <ProfileTapGestureDelegate>

@property (weak, nonatomic) IBOutlet UIView *profile;
@property (weak, nonatomic) IBOutlet UIView *sidebar;

@end

@implementation ProfileContainerViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.profile.alpha = 1;
    self.sidebar.alpha = 0;
    
    self.sidebar.layer.cornerRadius = 16;
    self.sidebar.layer.shadowColor = UIView.appearance.tintColor.CGColor;
    self.sidebar.layer.shadowOffset = CGSizeMake(-8.0f, 0);
    self.sidebar.layer.shadowRadius = 8.0f;
    self.sidebar.layer.shadowOpacity = 0.5f;
    self.sidebar.layer.masksToBounds = NO;
    
    if (!self.user) {
        self.user = [User currentUser];
    } else if (![self.user.objectId isEqual:[User currentUser].objectId]){
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    if (self.sidebar.alpha == 1) {
        [self didTapSidebar:self];
    }
}

#pragma mark - Action Handlers

- (IBAction)didTapSidebar:(id)sender {
    if (self.sidebar.alpha == 0) {
        [UIView animateWithDuration:0.5f animations:^{
            self.profile.frame = CGRectMake(self.profile.frame.origin.x-self.sidebar.frame.size.width, self.profile.frame.origin.y, self.profile.frame.size.width, self.profile.frame.size.height);
            self.profile.alpha = 0.5;
            self.sidebar.alpha = 1;
        }];
        [self.delegate didOpenSidebar:YES];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            self.profile.frame = CGRectMake(self.profile.frame.origin.x+self.sidebar.frame.size.width, self.profile.frame.origin.y, self.profile.frame.size.width, self.profile.frame.size.height);
            self.profile.alpha = 1;
            self.sidebar.alpha = 0;
        }];
        [self.delegate didOpenSidebar:NO];
    }
}

#pragma mark - ProfileTapGestureDelegate

- (void)didTapCloseSidebar {
    [self didTapSidebar:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.recipe = sender;
    } else if ([segue.identifier isEqualToString:@"Saved"]) {
        SavedViewController *savedViewController = [segue destinationViewController];
        savedViewController.user = self.user;
    } else if ([segue.identifier isEqualToString:@"Settings"]) {
        SettingsViewController *settingsViewController = [segue destinationViewController];
        settingsViewController.user = self.user;
    } else if ([segue.identifier isEqualToString:@"Buy"]) {
        BuyViewController *buyViewController = [segue destinationViewController];
        buyViewController.user = self.user;
    } else if ([segue.identifier isEqualToString:@"Profile Embed"]) {
        ProfileViewController *childViewController = [segue destinationViewController];
        if (!self.user) {
            self.user = [User currentUser];
        }
        childViewController.user = self.user;
        childViewController.delegate = self;
        childViewController.profileContainerViewController = self;
    }
}

@end
