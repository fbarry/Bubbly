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
#import <UserNotifications/UserNotifications.h>

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
@property (weak, nonatomic) IBOutlet UISegmentedControl *notificationsSegment;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeIntervalField;

@end

@implementation SettingsViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [Utilities roundImage:(UIImageView *)self.profilePicture];
    [Utilities roundImage:(UIImageView *)self.backgroundPicture];
        
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:self.user.profilePicture.url]];
    [self.profilePicture setImage:imageView.image forState:UIControlStateNormal];
    [imageView setImageWithURL:[NSURL URLWithString:self.user.backgroundPicture.url]];
    [self.backgroundPicture setImage:imageView.image forState:UIControlStateNormal];
    
    self.timeIntervalField.placeholder = [NSString stringWithFormat:@"%d", (self.user.notifictionTimeInterval.intValue / 60)];
    
    if ([self.user.FBConnected isEqualToNumber:[NSNumber numberWithInt:1]]) {
        self.FBSegment.selectedSegmentIndex = 1;
    }
    if ([self.user.weatherEnabled isEqualToNumber:[NSNumber numberWithInt:1]]) {
        self.weatherSegment.selectedSegmentIndex = 1;
    }
    if ([self.user.notificationsEnabled isEqualToNumber:[NSNumber numberWithInt:1]]) {
        self.notificationsSegment.selectedSegmentIndex = 1;
    } else {
        self.timeIntervalLabel.alpha = 0.3;
        self.timeIntervalField.alpha = 0.3;
    }
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

#pragma mark - Action Handlers

- (IBAction)didToggleNotifications:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.timeIntervalField.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.timeIntervalLabel.alpha = 0.3;
            self.timeIntervalField.alpha = 0.3;
        }];
    } else {
        self.timeIntervalField.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.timeIntervalLabel.alpha = 1;
            self.timeIntervalField.alpha = 1;
        }];
    }
}

- (IBAction)didTapImage:(UIButton *)sender {
    CameraView *camera = [[CameraView alloc] init];
    camera.delegate = self;
    camera.viewController = self;
    camera.name = sender.accessibilityIdentifier;
    [camera alertConfirmation];
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
    self.user.FBConnected = [NSNumber numberWithInteger:self.FBSegment.selectedSegmentIndex];
    self.user.weatherEnabled = [NSNumber numberWithInteger:self.weatherSegment.selectedSegmentIndex];
    self.user.notificationsEnabled = [NSNumber numberWithInteger:self.notificationsSegment.selectedSegmentIndex];
    
    if ([self.user.notificationsEnabled isEqualToNumber:[NSNumber numberWithInt:1]] && self.timeIntervalField.text.intValue > 0) {
        self.user.notifictionTimeInterval = [NSNumber numberWithInt:(self.timeIntervalField.text.intValue*60)];
        [Utilities changeNotificationsWithTimeInterval:self.user.notifictionTimeInterval.doubleValue inViewController:self];
    } else if ([self.user.notificationsEnabled isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [UNUserNotificationCenter.currentNotificationCenter removeAllPendingNotificationRequests];
    }
    
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

#pragma mark - CameraViewDelegate

- (void)setImage:(nonnull UIImage *)image withName:(nonnull NSString *)name {
    if ([name isEqualToString:@"profile"]) {
        [self.profilePicture setImage:image forState:UIControlStateNormal];
    } else if ([name isEqualToString:@"background"]) {
        [self.backgroundPicture setImage:image forState:UIControlStateNormal];
    }
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
