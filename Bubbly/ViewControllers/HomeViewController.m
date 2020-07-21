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

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPicture;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *acheivedLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *customValueField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet PieChartView *pieChart;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IntakeDayLog *dayLog;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.user = [User currentUser];
    [Utilities roundImage:self.backgroundPicture];
    [self.pieChart.legend setEnabled:NO];
    self.pieChart.holeRadiusPercent = 0.9;
    self.pieChart.holeColor = [UIColor clearColor];
    
    [self getDayLog];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboard = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboard.size.height;
    self.scrollView.contentInset = contentInset;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInset;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome Back, %@!", self.user.name];
    
    [self.backgroundPicture setImageWithURL:[NSURL URLWithString:self.user.backgroundPicture.url]];

    [self.segmentedControl setTitle:[NSString stringWithFormat:@"%@ oz", self.user.logAmounts[0]] forSegmentAtIndex:0];
    [self.segmentedControl setTitle:[NSString stringWithFormat:@"%@ oz", self.user.logAmounts[1]] forSegmentAtIndex:1];
    [self.segmentedControl setTitle:[NSString stringWithFormat:@"%@ oz", self.user.logAmounts[2]] forSegmentAtIndex:2];
    [self.segmentedControl setTitle:[NSString stringWithFormat:@"%@ oz", self.user.logAmounts[3]] forSegmentAtIndex:3];
    
    [self loadAnimation];
}

- (void)loadAnimation {
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
        
    [self.pieChart animateWithXAxisDuration:2 easingOption:ChartEasingOptionEaseInOutElastic];
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

- (IBAction)didTapLog:(id)sender {
    IntakeLog *logChange = [IntakeLog new];
    if (self.segmentedControl.selectedSegmentIndex != 4) {
        logChange.logAmount = [NSNumber numberWithInteger:[[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex] integerValue]];
    } else {
        logChange.logAmount = [NSNumber numberWithInteger:[self.customValueField.text integerValue]];
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

- (IBAction)didTapDelete:(id)sender {
    IntakeLog *logChange = [IntakeLog new];
    if (self.segmentedControl.selectedSegmentIndex != 4) {
        logChange.logAmount = [NSNumber numberWithInteger:[[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex] integerValue]];
    } else {
        logChange.logAmount = [NSNumber numberWithInteger:[self.customValueField.text integerValue]];
    }
    
    if ([logChange.logAmount compare:self.dayLog.achieved] > 0) {
        logChange.logAmount = self.dayLog.achieved;
    }
    
    logChange.logAmount = [NSNumber numberWithInteger:[logChange.logAmount integerValue] * -1];
    
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
