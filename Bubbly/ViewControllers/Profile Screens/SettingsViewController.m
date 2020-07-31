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

@interface SettingsViewController () <CameraViewDelegate, UITextFieldDelegate>

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
@property (weak, nonatomic) IBOutlet UISegmentedControl *appearanceSegment;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeIntervalField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) User *userCopy;

@end

@implementation SettingsViewController

#pragma mark - View

BOOL themeChanged = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.enterPasswordField.delegate = self;
    self.confirmPasswordField.delegate = self;
    
    self.userCopy = [self.user copyUser];
    self.saveButton.enabled = NO;
    self.saveButton.tintColor = [UIColor lightGrayColor];
    
    [Utilities roundImage:(UIImageView *)self.profilePicture];
    [Utilities roundImage:(UIImageView *)self.backgroundPicture];
        
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:self.user.profilePicture.url]];
    [self.profilePicture setImage:imageView.image forState:UIControlStateNormal];
    [imageView setImageWithURL:[NSURL URLWithString:self.user.backgroundPicture.url]];
    [self.backgroundPicture setImage:imageView.image forState:UIControlStateNormal];
    
    self.timeIntervalField.placeholder = [NSString stringWithFormat:@"%d", (self.user.notifictionTimeInterval.intValue / 60)];
    
    self.appearanceSegment.selectedSegmentIndex = self.user.theme.intValue;
    
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
        self.logFields[i].placeholder = [NSString stringWithFormat:@"%@", self.user.logAmounts[i]];
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
    
    [self updateUser];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Could not save profile"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            if (themeChanged) {
                NSNotification *newTheme = [[NSNotification alloc] initWithName:@"ThemeChangedEvent" object:nil userInfo:@{@"ThemeName" : self.user.theme}];
                [NSNotificationCenter.defaultCenter postNotification:newTheme];
            }
            
            if ([self.user.notificationsEnabled isEqualToNumber:[NSNumber numberWithInt:1]] && self.timeIntervalField.text.intValue > 0) {
                [Utilities changeNotificationsWithTimeInterval:self.user.notifictionTimeInterval.doubleValue inViewController:self];
            } else if ([self.user.notificationsEnabled isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [UNUserNotificationCenter.currentNotificationCenter removeAllPendingNotificationRequests];
            }
            
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
    [self updateUser];
    
    if (![self.userCopy compareTo:self.user]) {
        self.saveButton.enabled = YES;
        self.saveButton.tintColor = UIButton.appearance.tintColor;
    } else {
        self.saveButton.enabled = NO;
        self.saveButton.tintColor = [UIColor lightGrayColor];
    }
    
    [self.view endEditing:YES];
}

- (IBAction)didToggle:(id)sender {
    [self closeKeyboard:self];
}

#pragma mark - CameraViewDelegate

- (void)setImage:(nonnull UIImage *)image withName:(nonnull NSString *)name {
    [self closeKeyboard:self];
    if ([name isEqualToString:@"profile"]) {
        [self.profilePicture setImage:image forState:UIControlStateNormal];
    } else if ([name isEqualToString:@"background"]) {
        [self.backgroundPicture setImage:image forState:UIControlStateNormal];
    }
}

#pragma mark - TextFieldDelgate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        self.saveButton.enabled = YES;
        self.saveButton.tintColor = UIButton.appearance.tintColor;
    } else {
        self.saveButton.enabled = NO;
        self.saveButton.tintColor = [UIColor lightGrayColor];
    }
}

#pragma mark - Helper Functions

- (void)updateUser {
    if (![self.nameField.text isEqualToString:@""]) {
        self.user.name = self.nameField.text;
    } else {
        self.user.name = self.userCopy.name;
    }
    if (![self.emailField.text isEqualToString:@""]) {
        self.user.email = self.emailField.text;
    } else {
        self.user.email = self.userCopy.email;
    }
    if (![self.usernameField.text isEqualToString:@""]) {
        self.user.username = self.usernameField.text;
    } else {
        self.user.username = self.userCopy.username;
    }
    if (![self.weightField.text isEqualToString:@""]) {
        self.user.weight = [NSNumber numberWithFloat:[self.weightField.text floatValue]];
    } else {
        self.user.weight = self.userCopy.weight;
    }
    if (![self.usernameField.text isEqualToString:@""]) {
        self.user.exercise = [NSNumber numberWithFloat:[self.exerciseField.text floatValue]];
    } else {
        self.user.exercise = self.userCopy.exercise;
    }
    self.user.profilePicture = [Utilities getPFFileFromImage:self.profilePicture.imageView.image];
    self.user.backgroundPicture = [Utilities getPFFileFromImage:self.backgroundPicture.imageView.image];
    
    self.user.FBConnected = [NSNumber numberWithInteger:self.FBSegment.selectedSegmentIndex];
    self.user.weatherEnabled = [NSNumber numberWithInteger:self.weatherSegment.selectedSegmentIndex];
    self.user.notificationsEnabled = [NSNumber numberWithInteger:self.notificationsSegment.selectedSegmentIndex];
    
    NSMutableArray *newLogAmounts = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        [newLogAmounts addObject:[self.logFields[i].text isEqual:@""] ? self.userCopy.logAmounts[i] : self.logFields[i].text];
    }
    self.user.logAmounts = (NSArray *)newLogAmounts;
    
    self.user.theme = [NSNumber numberWithInteger:self.appearanceSegment.selectedSegmentIndex];
    if (self.appearanceSegment.selectedSegmentIndex != self.userCopy.theme.intValue) {
        themeChanged = YES;
    } else {
        themeChanged = NO;
    }
    
    if ([self.user.notificationsEnabled isEqualToNumber:[NSNumber numberWithInt:1]] && self.timeIntervalField.text.intValue > 0) {
        self.user.notifictionTimeInterval = [NSNumber numberWithInt:(self.timeIntervalField.text.intValue*60)];
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
