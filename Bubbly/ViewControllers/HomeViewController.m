//
//  HomeViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "HomeViewController.h"
#import "IntakeLog.h"
#import "Utilities.h"
#import "UIImageView+AFNetworking.h"
#import "IntakeDayLog.h"
#import <CoreLocation/CoreLocation.h>
#import "OWMWeatherAPI.h"
#import <PopupDialog-Swift.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "FacebookShareView.h"
#import <UserNotifications/UserNotifications.h>
#import "UIColor+ColorExtensions.h"
#import "WeatherIcon.h"
#import "BackgroundView.h"
#import <CircleProgressView-Swift.h>

static const int numLogs = 4;

@interface HomeViewController () <CLLocationManagerDelegate, UNUserNotificationCenterDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *acheivedLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet CircleProgressView *progressView;
@property (weak, nonatomic) IBOutlet WeatherIcon *weatherIcon;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *closeKeyboard;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *weather;
@property (weak, nonatomic) IBOutlet UIButton *log;
@property (weak, nonatomic) IBOutlet UIButton *delete;
@property (strong, nonatomic) IntakeDayLog *dayLog;
@property (strong, nonatomic) User *user;

@end

@implementation HomeViewController

float temp, feelsLike, humidity;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [User currentUser];
    
    self.log.layer.cornerRadius = self.delete.layer.cornerRadius = 16;
    self.delete.backgroundColor = [UIColor extraLightGray];
    
    self.progressView.layer.shadowOffset = CGSizeMake(0, 8.0f);
    self.progressView.layer.shadowRadius = 8.0f;
    self.progressView.layer.shadowOpacity = 0.5f;
    self.progressView.layer.masksToBounds = NO;
    
    self.progressView.trackBackgroundColor = UINavigationBar.appearance.barTintColor;
    self.progressView.trackFillColor = UIButton.appearance.tintColor;
    self.progressView.centerFillColor = UIView.appearance.backgroundColor;
    
    [self.closeKeyboard setEnabled:NO];
    
    UITapGestureRecognizer *weatherTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapWeather:)];
    [self.weatherIcon addGestureRecognizer:weatherTapGestureRecognizer];
    
    self.textView.layer.cornerRadius = 16;
        
    [Utilities roundImage:self.weatherIcon];
    self.weatherIcon.layer.borderWidth = 0.5f;
    self.weatherIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    [Utilities roundImage:(UIImageView *)self.infoButton];
    self.infoButton.layer.borderWidth = 0.5f;
    self.infoButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self getDayLog];
        
    if ([self.user.notificationsEnabled isEqualToNumber:[NSNumber numberWithInt:2]]) {
        [self defineNotificationsEnabled];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
        
    self.progressView.layer.shadowColor = UIView.appearance.tintColor.CGColor;
    self.log.backgroundColor = [UIButton.appearance.tintColor colorWithAlphaComponent:0.3];
    
    if ([self.user.weatherEnabled isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [self.weatherIcon setHidden:NO];
        [self.weatherIcon setUserInteractionEnabled:YES];
        [self.infoButton setHidden:NO];
        [self.infoButton setEnabled:YES];
        if (!self.locationManager) {
            [self setUpLocationManager];
        }
    } else if ([self.user.weatherEnabled isEqualToNumber:[NSNumber numberWithInt:2]]) {
        [self.weatherIcon setImage:[UIImage systemImageNamed:@"questionmark.circle"]];
        [Utilities roundImage:self.weatherIcon];
        self.weatherIcon.layer.borderWidth = 0.5f;
        self.weatherIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        [self.weatherIcon setHidden:YES];
        [self.weatherIcon setUserInteractionEnabled:NO];
        [self.infoButton setHidden:YES];
        [self.infoButton setEnabled:NO];
    }
    
    NSArray *name = [self.user.name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome back, %@!", name[0]];
    
    NSLog(@"%@", self.user);
    NSLog(@"%@", self.user.backgroundPicture.url);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.user.backgroundPicture.url]] placeholderImage:[UIImage imageNamed:@"bottle"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.progressView.centerImage = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // tap to try again
        NSLog(@"failed to load");
    }];
    
    for (int i = 0; i < numLogs; i++) {
        [self.segmentedControl setTitle:[NSString stringWithFormat:@"%@ oz", self.user.logAmounts[i]] forSegmentAtIndex:i];
    }
    
    [self loadAnimation];
}

- (void)loadAnimation {
    if (!self.dayLog) {
        return;
    }
    
    self.goalLabel.text = [NSString stringWithFormat:@"Goal: %d oz", [self.dayLog.goal intValue]];
    self.acheivedLabel.text = [NSString stringWithFormat:@"Achieved: %d oz", [self.dayLog.achieved intValue]];
    
    double percent = [self.dayLog.achieved doubleValue]/[self.dayLog.goal doubleValue];
    if (percent >= 1) {
        percent = 1;
        self.progressView.trackFillColor = [UIColor greenColor];
    } else {
        self.progressView.trackFillColor = UIButton.appearance.tintColor;
    }
    
    [self.progressView setProgress:percent animated:YES];
}

#pragma mark - Define User Settings

- (void)defineNotificationsEnabled {
    self.user.notificationsEnabled = [NSNumber numberWithInt:0];
    [Utilities presentConfirmationInViewController:self
                                         withTitle:@"Would you like to enable water consumption reminders?"
                                           message:@"You can change this option in app settings"
                                             image:nil
                                        yesHandler:^{ [self setUpNotificationManager]; }
                                         noHandler:^{
        [self.user saveInBackground];
    }];
}

- (void)defineWeatherEnabled {
    self.user.weatherEnabled = [NSNumber numberWithInt:0];
    [Utilities presentConfirmationInViewController:self
                                         withTitle:@"Would you like to view the weather in your area for increased water intake recommendations?"
                                           message:@"You can change this option in app settings"
                                             image:nil
                                        yesHandler:^{
        self.user.weatherEnabled = [NSNumber numberWithInt:1];
        [self setUpLocationManager];
        [self.user saveInBackground];
    }
                                         noHandler:^{
        [self.weatherIcon setHidden:YES];
        [self.weatherIcon setUserInteractionEnabled:NO];
        [self.infoButton setHidden:YES];
        [self.infoButton setEnabled:NO];
        [self.user saveInBackground];
    }];
}

#pragma mark - Location Manager

- (void)setUpLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == SKCloudServiceAuthorizationStatusDenied) {
        [self.user.weatherEnabled isEqualToNumber:[NSNumber numberWithInt:0]];
    } else {
        [self updateWeather];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self updateWeather];
}

#pragma mark - Notification Center

- (void)setUpNotificationManager {
    PopupDialog *options = [self setUpNotificationPrompt];
    
    UNUserNotificationCenter *center = UNUserNotificationCenter.currentNotificationCenter;
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Could not set up notifications"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            if (granted) {
                self.user.notificationsEnabled = [NSNumber numberWithInt:1];
                [self.user saveInBackground];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:options animated:YES completion:nil];
                });
            }
        }
    }];
}

- (PopupDialog *)setUpNotificationPrompt {
    PopupDialog *options = [[PopupDialog alloc] initWithTitle:@"Choose a time interval"
                                                      message:nil image:nil
                                              buttonAlignment:UILayoutConstraintAxisHorizontal
                                              transitionStyle:PopupDialogTransitionStyleFadeIn
                                               preferredWidth:200
                                          tapGestureDismissal:NO
                                          panGestureDismissal:NO
                                                hideStatusBar:YES
                                                   completion:^{
        [Utilities changeNotificationsWithTimeInterval:self.user.notifictionTimeInterval.doubleValue inViewController:self];
    }];
    
    PopupDialogButton *oneMinute = [[PopupDialogButton alloc] initWithTitle:@"1 min" height:50 dismissOnTap:YES action:^{
        self.user.notifictionTimeInterval = [NSNumber numberWithInt:(1*60)];
    }];
    PopupDialogButton *oneHour = [[PopupDialogButton alloc] initWithTitle:@"1 hour" height:50 dismissOnTap:YES action:^{
        self.user.notifictionTimeInterval = [NSNumber numberWithInt:(60*60)];
    }];
    PopupDialogButton *twoHours = [[PopupDialogButton alloc] initWithTitle:@"2 hours" height:50 dismissOnTap:YES action:^{
        self.user.notifictionTimeInterval = [NSNumber numberWithInt:(120*60)];
    }];
    PopupDialogButton *cancel = [[PopupDialogButton alloc] initWithTitle:@"Cancel" height:50 dismissOnTap:YES action:^{
        self.user.notificationsEnabled = [NSNumber numberWithInt:0];
    }];
    
    [options addButtons:@[oneMinute, oneHour, twoHours, cancel]];
    
    return options;
}

#pragma mark - Facebook Sharing

- (void)sharePost {
    FacebookShareView *share = [[FacebookShareView alloc] initWithTitle:@"Congratulations on meeting your goal! Would you like to share to Facebook?"
                                                                 photo:[UIImage imageNamed:@"share-goal"]
                                                                caption:@"I reached my water intake goal on Bubbly!"
                                                       inViewController:self];
    [share presentShareView];
}

#pragma mark - API Calls

- (void)updateWeather {    
    OWMWeatherAPI *weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"9d02fda4b8887c82b20395baeaa1154e"];
    [weatherAPI setTemperatureFormat:kOWMTempKelvin];
    
    [weatherAPI currentWeatherByCoordinate:self.locationManager.location.coordinate withCallback:^(NSError *error, NSDictionary *result) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Cannot load weather info"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            self.weather = result;
            NSArray *weather = result[@"weather"];
            NSDictionary *dictionary = weather[0];
            [self.weatherIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/wn/%@@2x.png", dictionary[@"icon"]]]];
            
            NSDictionary *main = result[@"main"];
            
            temp = [self kelvinToFarenheit:[main[@"temp"] floatValue]];
            feelsLike = [self kelvinToFarenheit:[main[@"feels_like"] floatValue]];
            humidity = [main[@"humidity"] floatValue];
            
            if (feelsLike >= 90) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"The weather outside is frightful..."
                                                            message:[NSString stringWithFormat:@"A whopping %.0f°\nRemember to drink extra water!", feelsLike]];
                self.infoButton.tintColor = [UIColor redColor];
            } else {
                self.infoButton.tintColor = [UIColor darkGrayColor];
            }
            
            [Utilities roundImage:self.weatherIcon];
            self.weatherIcon.layer.borderWidth = 0.5f;
            self.weatherIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }];
}

- (void)getDayLog {
    [self.activityIndicator startAnimating];
    
    PFQuery *logQuery = [PFQuery queryWithClassName:@"IntakeDayLog"];
    [logQuery whereKey:@"user" equalTo:self.user];
    [logQuery addDescendingOrder:@"createdAt"];
    logQuery.limit = 1;
    
    [logQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Could not load log"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            if (![self validLog:objects]) {
                [self createNewLog];
            } else {
                self.dayLog = objects[0];
                [self loadAnimation];
            }
        }
        [self.activityIndicator stopAnimating];
    }];
}

- (void)createNewLog {
    self.dayLog = [IntakeDayLog new];
    self.dayLog.goal = [NSNumber numberWithFloat:[self.user.weight floatValue] * 2.0 / 3.0 + 12.0 * [self.user.exercise floatValue] / 30.0];
    self.dayLog.achieved = [NSNumber numberWithInt:0];
    self.dayLog.user = self.user;
    
    [self.dayLog saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Could not create new log"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [self loadAnimation];
        }
    }];
}

- (void)recordLogChangeWithSender:(UIButton *)sender {
    IntakeLog *logChange = [IntakeLog new];
    if (self.segmentedControl.selectedSegmentIndex != 4) {
        logChange.logAmount = [NSNumber numberWithInteger:[[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex] integerValue]];
        [self confirmationWithLog:logChange sender:sender andCompletion:^{
            if ([sender.titleLabel.text isEqualToString:@"Delete"]) {
                if ([logChange.logAmount compare:self.dayLog.achieved] > 0) {
                    logChange.logAmount = self.dayLog.achieved;
                }
                logChange.logAmount = [NSNumber numberWithInteger:[logChange.logAmount integerValue] * -1];
            }
            [self saveLogChange:logChange withSender:sender];
        }];
    } else {
        UIAlertController *custom = [UIAlertController alertControllerWithTitle:@"Enter log amount"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [custom addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"in ounces";
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }];
        [custom addAction:[UIAlertAction actionWithTitle:sender.titleLabel.text style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            logChange.logAmount = [NSNumber numberWithInteger:[custom.textFields[0].text integerValue]];
            [self confirmationWithLog:logChange sender:sender andCompletion:^{
                if ([sender.titleLabel.text isEqualToString:@"Delete"]) {
                    if ([logChange.logAmount compare:self.dayLog.achieved] > 0) {
                        logChange.logAmount = self.dayLog.achieved;
                    }
                    logChange.logAmount = [NSNumber numberWithInteger:[logChange.logAmount integerValue] * -1];
                }
                [self saveLogChange:logChange withSender:sender];
            }];
        }]];
        [custom addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:custom animated:YES completion:nil];
    }
}

- (void)confirmationWithLog:(IntakeLog *)logChange sender:(UIButton *)sender andCompletion:(void (^)(void))completion {
    if ([sender.titleLabel.text isEqualToString:@"Delete"]) {
        [Utilities presentConfirmationInViewController:self
                                            withTitle:[NSString stringWithFormat:@"Are you sure you want to delete %@ ounces?", logChange.logAmount]
                                                message:nil
                                                 image:nil
                                            yesHandler:completion
                                             noHandler:nil];
    } else {
        completion();
    }
}

- (void)saveLogChange:(IntakeLog *)logChange withSender:(UIButton *)sender {
    BOOL belowGoal = [self.dayLog.achieved intValue] < [self.dayLog.goal intValue];
    
    self.dayLog.achieved = [NSNumber numberWithInteger:[self.dayLog.achieved integerValue] + [logChange.logAmount integerValue]];
    
    PFRelation *relation = [self.dayLog relationForKey:@"logChanges"];
    [relation addObject:logChange];
        
    [logChange saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Could not update log"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [self.dayLog saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    [Utilities presentOkAlertControllerInViewController:self
                                                              withTitle:@"Could not update log"
                                                                message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
                } else {
                    [self loadAnimation];
                    if (belowGoal && [self.dayLog.achieved intValue] >= [self.dayLog.goal intValue]) {
                        if ([self.user.FBConnected isEqualToNumber:[NSNumber numberWithInt:1]]) {
                            [self sharePost];
                        } else if ([self.user.FBConnected isEqualToNumber:[NSNumber numberWithInt:2]]) {
                            [self.user.FBConnected isEqualToNumber:[NSNumber numberWithInt:0]];
                            [Utilities presentConfirmationInViewController:self
                                                                 withTitle:@"Would you like to enable share to Facebook?"
                                                                   message:@"You can change this option in app settings"
                                                                     image:nil
                                                                yesHandler:^{
                                [self.user.FBConnected isEqualToNumber:[NSNumber numberWithInt:1]];
                                [self sharePost];
                            }
                                                                 noHandler:nil];
                        }
                    }
                }
            }];
        }
    }];
}

#pragma mark - Action Handlers

- (IBAction)didTapWeather:(id)sender {
    if ([self.user.weatherEnabled isEqualToNumber:[NSNumber numberWithInt:2]]) {
        [self defineWeatherEnabled];
    } else {
        NSString *message = [NSString stringWithFormat:@"Temparature: %.1f°\nFeels Like: %.1f°\nHumidity: %.0f%%", temp, feelsLike, humidity];
        if (feelsLike >= 90) {
            message = [message stringByAppendingString:@"\nRemember to drink extra water!"];
        }
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Weather"
                                                    message:message];
    }
}

- (IBAction)didTapLog:(UIButton *)sender {
    [self recordLogChangeWithSender:sender];
}

- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"Compose" sender:self];
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - Helper Functions

- (float)kelvinToFarenheit:(float)kelvin {
    return (kelvin - 273.15) * 9.0 / 5.0 + 32;
}

- (BOOL)validLog:(NSArray *)objects {
    if (objects.count == 0) return false;
    
    IntakeDayLog *log = objects[0];
    
    if (![NSCalendar.currentCalendar isDate:log.createdAt inSameDayAsDate:[NSDate date]]) return false;
    
    return true;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
