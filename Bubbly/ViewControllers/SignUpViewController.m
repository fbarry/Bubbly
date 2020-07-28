//
//  SignUpViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SignUpViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "User.h"
#import "CameraView.h"
#import "Utilities.h"

@interface SignUpViewController () <CameraViewDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UITextField *exerciseField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *signup;

@end

@implementation SignUpViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signup.layer.cornerRadius = 16;
        
    [Utilities roundImage:(UIImageView *)self.profilePicture];
}

#pragma mark - Action Handling

- (IBAction)didTapProfile:(id)sender {
    CameraView *camera = [[CameraView alloc] init];
    camera.viewController = self;
    camera.delegate = self;
    camera.name = @"camera";
    [camera alertConfirmation];
}


- (IBAction)didTapSignUp:(UIButton *)sender {
    [self didTapBackground:self];
    if ([self invalidInput]) {
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Invalid Input"
                                                    message:@"One or more required fields is blank"];
    } else if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Invalid Input"
                                                    message:@"Passwords do not match"];
    } else {
        sender.userInteractionEnabled = NO;
        [self.activityIndicator startAnimating];

        User *user = [User new];
        
        user.username = self.usernameField.text;
        user.password = self.passwordField.text;
        user.email = self.emailField.text;
        
        user.name = self.nameField.text;
        user.profilePicture = [Utilities getPFFileFromImage:self.profilePicture.imageView.image];
        
        user.weight = [NSNumber numberWithFloat:[self.weightField.text floatValue]];
        user.exercise = [NSNumber numberWithFloat:[self.exerciseField.text floatValue]];
        
        user.backgroundPicture = [Utilities getPFFileFromImage:[UIImage imageNamed:@"bottle"]];
        user.logAmounts = @[@1, @2, @4, @8];
        
        user.FBConnected = [NSNumber numberWithInt:3];
        user.weatherEnabled = [NSNumber numberWithInt:3];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"Could not register user"
                                                            message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            } else {
                [self performSegueWithIdentifier:@"Home" sender:self];
            }
            sender.userInteractionEnabled = YES;
            [self.activityIndicator stopAnimating];
        }];
    }
}


- (IBAction)didTapLogin:(id)sender {
    [self performSegueWithIdentifier:@"Login" sender:self];
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - Helper Functions

- (void)setImage:(UIImage *)image withName:(NSString *)name {
    [self.profilePicture setImage:image forState:UIControlStateNormal];
}

- (BOOL)invalidInput {
    return [self.nameField.text isEqual:@""] || [self.emailField.text isEqual:@""] || [self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
