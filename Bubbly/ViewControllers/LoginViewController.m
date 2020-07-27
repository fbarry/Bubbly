//
//  WelcomeViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "LoginViewController.h"
#import "Utilities.h"
#import "User.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *signup;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.login.layer.cornerRadius = 16;
    self.signup.layer.cornerRadius = 16;
}

- (IBAction)didTapLogin:(UIButton *)sender {
    [self didTapBackground:self];
    sender.userInteractionEnabled = NO;
    [self.activityIndicator startAnimating];
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [User logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error Logging In"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [self performSegueWithIdentifier:@"Home" sender:self];
        }
        sender.userInteractionEnabled = YES;
        [self.activityIndicator stopAnimating];
    }];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"Signup" sender:self];
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
