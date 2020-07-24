//
//  WelcomeViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *signup;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.login.layer.cornerRadius = 16;
    self.signup.layer.cornerRadius = 16;
}

- (IBAction)didTapLogin:(id)sender {
    [self performSegueWithIdentifier:@"Login" sender:self];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"Signup" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
