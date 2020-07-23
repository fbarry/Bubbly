//
//  HomeViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "HomeViewController.h"
#import "User.h"
#import "IntakeLog.h"
#import "Utilities.h"
#import "UIImageView+AFNetworking.h"
#import <Charts-Swift.h>
#import "IntakeDayLog.h"
#import <CoreLocation/CoreLocation.h>
#import "OWMWeatherAPI.h"
#import <PopupDialog-Swift.h>

@interface HomeViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPicture;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *acheivedLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *customValueField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet PieChartView *pieChart;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *closeKeyboard;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IntakeDayLog *dayLog;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *weather;

@end

@implementation HomeViewController

float temp, feelsLike, humidity;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.closeKeyboard setEnabled:NO];
    
    [self.weatherIcon setHidden:YES];
    [self.weatherIcon setUserInteractionEnabled:NO];
    UITapGestureRecognizer *weatherTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapWeather:)];
    [self.weatherIcon addGestureRecognizer:weatherTapGestureRecognizer];
    
    [self.infoButton setHidden:YES];
    [self.infoButton setEnabled:NO];
    
    self.textView.layer.cornerRadius = 16;
    
    self.user = [User currentUser];
    
    [Utilities roundImage:self.backgroundPicture];
    self.backgroundPicture.layer.borderWidth = 0;
    [Utilities roundImage:self.weatherIcon];
    self.weatherIcon.layer.borderWidth = 0;
    
    [self.pieChart.legend setEnabled:NO];
    self.pieChart.holeRadiusPercent = 0.9;
    self.pieChart.holeColor = [UIColor clearColor];
    [self.pieChart setUserInteractionEnabled:NO];
    
    [self getDayLog];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self updateWeather];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self updateWeather];
}

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
            [self.weatherIcon setHidden:NO];
            [self.weatherIcon setUserInteractionEnabled:YES];
            [self.infoButton setHidden:NO];
            [self.infoButton setEnabled:YES];
            
            NSDictionary *main = result[@"main"];
            
            temp = [self kelvinToFarenheit:[main[@"temp"] floatValue]];
            feelsLike = [self kelvinToFarenheit:[main[@"feels_like"] floatValue]];
            humidity = [main[@"humidity"] floatValue];
            
            if (feelsLike >= 90) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"The weather outside is frightful..."
                                                            message:[NSString stringWithFormat:@"A whopping %.0f°\nRemember to drink extra water!", feelsLike]];
                self.infoButton.tintColor = [UIColor systemRedColor];
            } else {
                self.infoButton.tintColor = [UIColor darkGrayColor];
            }
            
            [Utilities roundImage:self.weatherIcon];
            self.weatherIcon.layer.borderWidth = 0;
        }
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self.closeKeyboard setEnabled:YES];
    CGRect keyboard = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboard.size.height;
    self.scrollView.contentInset = contentInset;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.closeKeyboard setEnabled:NO];
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInset;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome Back, %@!", self.user.name];
    
    [self.backgroundPicture setImageWithURL:[NSURL URLWithString:self.user.backgroundPicture.url]];
    
    for (int i = 0; i < 4; i++) {
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
    
    double percent = [self.dayLog.achieved doubleValue]/[self.dayLog.goal doubleValue]*100;
    PieChartDataSet *data = [[PieChartDataSet alloc] init];
    [data setDrawValuesEnabled:NO];
    data.colors = @[[UIColor systemTealColor], [UIColor systemGray6Color]];
    
    if (percent > 100) {
        if ([data addEntry:[[PieChartDataEntry alloc] initWithValue:100]]) {
            self.pieChart.data = [[PieChartData alloc] initWithDataSet:data];
        } else {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error loading home screen"
                                                        message:nil];
        }
    } else {
        if ([data addEntry:[[PieChartDataEntry alloc] initWithValue:percent]] && [data addEntry:[[PieChartDataEntry alloc] initWithValue:100-percent]]) {
            self.pieChart.data = [[PieChartData alloc] initWithDataSet:data];
        } else {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error loading home screen"
                                                        message:nil];
        }
    }
    
    [Utilities roundImage:self.backgroundPicture];
    self.backgroundPicture.layer.borderWidth = 0;
        
    [self.pieChart animateWithXAxisDuration:1.2 easingOption:ChartEasingOptionEaseOutCirc];
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
            } else {
                self.dayLog = objects[0];
                [self loadAnimation];
            }
        }
        [self.activityIndicator stopAnimating];
    }];
}

- (BOOL)validLog:(NSArray *)objects {
    if (objects.count == 0) return false;
    
    IntakeDayLog *log = objects[0];
    
    if (![NSCalendar.currentCalendar isDate:log.createdAt inSameDayAsDate:[NSDate date]]) return false;
    
    return true;
}

- (IBAction)didTapWeather:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Temparature: %.1f°\nFeels Like: %.1f°\nHumidity: %.0f", temp, feelsLike, humidity];
    if (feelsLike >= 90) {
        message = [message stringByAppendingString:@"\nRemember to drink extra water!"];
    }
    [Utilities presentOkAlertControllerInViewController:self
                                              withTitle:@"Weather"
                                                message:message];
}

- (float)kelvinToFarenheit:(float)kelvin {
    return (kelvin - 273.15) * 9.0 / 5.0 + 32;
}

- (IBAction)didTapLog:(UIButton *)sender {
    IntakeLog *logChange = [IntakeLog new];
    if (self.segmentedControl.selectedSegmentIndex != 4) {
        logChange.logAmount = [NSNumber numberWithInteger:[[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex] integerValue]];
    } else {
        logChange.logAmount = [NSNumber numberWithInteger:[self.customValueField.text integerValue]];
    }
    
    if ([sender.currentTitle isEqualToString:@"Delete"]) {
        if ([logChange.logAmount compare:self.dayLog.achieved] > 0) {
            logChange.logAmount = self.dayLog.achieved;
        }
        logChange.logAmount = [NSNumber numberWithInteger:[logChange.logAmount integerValue] * -1];
    }
    
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
                    if (self.dayLog.achieved >= self.dayLog.goal) {
                        
                    }
                }
            }];
        }
    }];
}

- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"Compose" sender:self];
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
