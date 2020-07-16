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

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIView *savedView;
@property (weak, nonatomic) IBOutlet UIView *buyView;
@property (strong, nonatomic) User *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataView.alpha = 1;
    self.savedView.alpha = 0;
    self.buyView.alpha = 0;
    
    self.user = [User currentUser];
    
    [Utilities roundImage:self.profilePicture];
    
    [self.profilePicture setImageWithURL:[NSURL URLWithString:self.user.profilePicture.url]];
    self.nameLabel.text = self.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.user.username];
    self.bioLabel.text = self.user.bio;
}

- (IBAction)didSelectIndex:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.dataView.alpha = 1;
            self.savedView.alpha = 0;
            self.buyView.alpha = 0;
            break;
        case 1:
            self.dataView.alpha = 0;
            self.savedView.alpha = 1;
            self.buyView.alpha = 0;
            break;
        case 2:
            self.dataView.alpha = 0;
            self.savedView.alpha = 0;
            self.buyView.alpha = 1;
            break;
        default:
            break;
    }
}

- (IBAction)didTapSettings:(id)sender {
    [self performSegueWithIdentifier:@"Settings" sender:self];
}

- (IBAction)didTapLogout:(id)sender {
    [Utilities presentConfirmationInViewController:self withTitle:@"Are you sure you want to logout?" yesHandler:^(UIAlertAction * _Nonnull action) {
        SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        sceneDelegate.window.rootViewController = welcomeViewController;

        [User logOut];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.recipe = sender;
    }
}

@end
