//
//  SettingsViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utilities.h"
#import "CameraView.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <MBProgressHUD/MBProgressHUD.h>

static const int numLogs = 4;

@interface SettingsViewController () <CameraViewDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *profilePicture;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *enterPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UITextField *exerciseField;
@property (strong, nonatomic) IBOutlet UIButton *backgroundPicture;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray<UITextField *> *logFields;
@property (weak, nonatomic) IBOutlet UISegmentedControl *FBSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *weatherSegment;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [Utilities roundImage:(UIImageView *)self.profilePicture];
    [Utilities roundImage:(UIImageView *)self.backgroundPicture];
        
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:self.user.profilePicture.url]];
    [self.profilePicture setImage:imageView.image forState:UIControlStateNormal];
    [imageView setImageWithURL:[NSURL URLWithString:self.user.backgroundPicture.url]];
    [self.backgroundPicture setImage:imageView.image forState:UIControlStateNormal];
    
    self.FBSegment.selectedSegmentIndex = self.user.FBConnected;
    self.weatherSegment.selectedSegmentIndex = self.user.weatherEnabled;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
            
    self.nameField.placeholder = self.user.name;
    self.emailField.placeholder = self.user.email;
    self.usernameField.placeholder = self.user.username;
    self.weightField.placeholder = [NSString stringWithFormat:@"Weight: %@ lbs", self.user.weight];
    self.exerciseField.placeholder = [NSString stringWithFormat:@"Exercise: %@ mins", self.user.exercise];
    for (int i = 0; i < numLogs; i++) {
        self.logFields[i].text = [NSString stringWithFormat:@"%@", self.user.logAmounts[i]];
    }
}

- (IBAction)didTapImage:(UIButton *)sender {
    CameraView *camera = [[CameraView alloc] init];
    camera.delegate = self;
    camera.viewController = self;
    camera.name = sender.accessibilityIdentifier;
    [camera alertConfirmation];
}

- (void)setImage:(nonnull UIImage *)image withName:(nonnull NSString *)name {
    if ([name isEqualToString:@"profile"]) {
        [self.profilePicture setImage:image forState:UIControlStateNormal];
    } else if ([name isEqualToString:@"background"]) {
        [self.backgroundPicture setImage:image forState:UIControlStateNormal];
    }
}

- (IBAction)didTapSave:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (![self.enterPasswordField.text isEqualToString:@""]) {
        if (![self.enterPasswordField.text isEqualToString:self.confirmPasswordField.text]) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"New passwords do not match"
                                                        message:@"Re-enter to try again"];
            return;
        } else {
            self.user.password = self.enterPasswordField.text;
        }
    }
    if (![self.nameField.text isEqualToString:@""]) {
        self.user.name = self.nameField.text;
    }
    if (![self.emailField.text isEqualToString:@""]) {
        self.user.email = self.emailField.text;
    }
    if (![self.usernameField.text isEqualToString:@""]) {
        self.user.username = self.usernameField.text;
    }
    if (![self.weightField.text isEqualToString:@""]) {
        self.user.weight = [NSNumber numberWithFloat:[self.weightField.text floatValue]];
    }
    if (![self.usernameField.text isEqualToString:@""]) {
        self.user.exercise = [NSNumber numberWithFloat:[self.exerciseField.text floatValue]];
    }
    self.user.profilePicture = [Utilities getPFFileFromImage:self.profilePicture.imageView.image];
    self.user.backgroundPicture = [Utilities getPFFileFromImage:self.backgroundPicture.imageView.image];
    self.user.logAmounts = @[self.logFields[0].text, self.logFields[1].text, self.logFields[2].text, self.logFields[3].text];
    self.user.FBConnected = self.FBSegment.selectedSegmentIndex;
    self.user.weatherEnabled = self.weatherSegment.selectedSegmentIndex;
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Could not save profile"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            UIAlertController *success = [UIAlertController alertControllerWithTitle:@"Changes saved successfully"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:success animated:YES completion:nil];
            [success dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)closeKeyboard:(id)sender {
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
