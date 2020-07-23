//
//  ProfileViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "ProfileViewController.h"
#import "Utilities.h"
#import "SceneDelegate.h"
#import "WelcomeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "SavedViewController.h"
#import "DetailsViewController.h"
#import "Recipe.h"
#import "ProfileContainerViewController.h"
#import "DataViewController.h"
#import "SavedViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (strong, nonatomic) id<ProfileProtocol>profile;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataView.alpha = 1;
    self.customView.alpha = 0;
    
    [Utilities roundImage:self.profilePicture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
        
    self.profile = self.user;
    
    [self.profilePicture setImageWithURL:self.profile.profilePictureURL];
    self.nameLabel.text = self.profile.name;
    self.usernameLabel.text = self.profile.profileUsername;
    self.bioLabel.text = self.profile.bio;
}

- (IBAction)didSelectIndex:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.dataView.alpha = 1;
            self.customView.alpha = 0;
            break;
        case 1:
            self.dataView.alpha = 0;
            self.customView.alpha = 1;
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Data Embed"]) {
        DataViewController *childViewController = [segue destinationViewController];
        childViewController.user = self.user;
    } else if ([segue.identifier isEqualToString:@"Custom Embed"]) {
        SavedViewController *childViewController = [segue destinationViewController];
        childViewController.user = self.user;
    }
}

@end
