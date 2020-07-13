//
//  SignUpViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"
#import "CameraView.h"
#import "Utilities.h"

@interface SignUpViewController () <CameraViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UITextField *exerciseField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapProfile:(id)sender {
    CameraView *camera = [[CameraView alloc] init];
    camera.viewController = self;
    camera.delegate = self;
    [camera alertConfirmation];
}

- (void)setImage:(UIImage *)image {
    [self.profilePicture setImage:image forState:UIControlStateNormal];
}

- (IBAction)didTapSignUp:(id)sender {
    if ([self invalidInput]) {
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Invalid Input"
                                                    message:@"One or more required fields is blank"];
    } else if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Invalid Input"
                                                    message:@"Passwords do not match"];
    } else {
        User *user = [User new];
        
        user.username = self.usernameField.text;
        user.password = self.passwordField.text;
        user.email = self.emailField.text;
        
        user.profile = [Profile new];
        user.health = [Health new];
        user.settings = [Settings new];
        
        user.profile.name = self.nameField.text;
        user.profile.profilePicture = [Utilities getPFFileFromImage:self.profilePicture.imageView.image];
        
        user.health.weight = [NSNumber numberWithFloat:[self.weightField.text floatValue]];
        user.health.exercise = [NSNumber numberWithFloat:[self.exerciseField.text floatValue]];
        
        user.settings.backgroundPicture = [Utilities getPFFileFromImage:[UIImage imageNamed:@"bottle"]];
        user.settings.logAmounts = @[@1, @2, @4, @8];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"Could not register user"
                                                            message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            } else {
                [self performSegueWithIdentifier:@"Home" sender:self];
            }
        }];
    }
}

- (BOOL)invalidInput {
    return [self.nameField.text isEqual:@""] || [self.emailField.text isEqual:@""] || [self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""];
}

- (IBAction)didTapBack:(id)sender {
    [self performSegueWithIdentifier:@"Welcome" sender:self];
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
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
