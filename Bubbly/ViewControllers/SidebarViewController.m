//
//  SidebarViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/23/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SidebarViewController.h"
#import "Utilities.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "User.h"

@interface SidebarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saved;
@property (weak, nonatomic) IBOutlet UIButton *ingredients;
@property (weak, nonatomic) IBOutlet UIButton *settings;
@property (weak, nonatomic) IBOutlet UIButton *logout;

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)didTapSettings:(id)sender {
    [self.parentViewController performSegueWithIdentifier:@"Settings" sender:self];
}

- (IBAction)didTapSaved:(id)sender {
    [self.parentViewController performSegueWithIdentifier:@"Saved" sender:self];
}

- (IBAction)didTapBuy:(id)sender {
    [self.parentViewController performSegueWithIdentifier:@"Buy" sender:self];
}

- (IBAction)didTapLogout:(id)sender {
    [Utilities presentConfirmationInViewController:self withTitle:@"Are you sure you want to logout?" yesHandler:^{
        SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        sceneDelegate.window.rootViewController = welcomeViewController;

        [User logOut];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
