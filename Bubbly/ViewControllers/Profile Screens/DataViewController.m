//
//  DataViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/15/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "DataViewController.h"
#import <Charts-Swift.h>
#import "IntakeLog.h"
#import "IntakeDayLog.h"
#import "Utilities.h"
#import "ProfileContainerViewController.h"
#import <PopupDialog-Swift.h>
#import "BackgroundView.h"
#import "UIColor+ColorExtensions.h"

@interface DataViewController () <IChartAxisValueFormatter>

@property (strong, nonatomic) IBOutlet LineChartView *lineChart;
@property (strong, nonatomic) NSMutableArray<IntakeDayLog *> *chartData;

@end

@implementation DataViewController

NSDate *referenceDate;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lineChart.userInteractionEnabled = NO;
    [self.lineChart.chartDescription setEnabled:NO];
    [self.lineChart.rightAxis setEnabled:NO];
    [self.lineChart.legend setEnabled:NO];
    
    referenceDate = [self getDateAtMidnight:[NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:-20 toDate:[NSDate date] options:0]];
    
    ChartXAxis *xAxis = self.lineChart.xAxis;
    xAxis.valueFormatter = self;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.granularity = 1.0;
    xAxis.labelRotationAngle = -45;
    xAxis.gridColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    ChartYAxis *yAxis = self.lineChart.leftAxis;
    yAxis.axisMinimum = 0;
    yAxis.gridColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.lineChart.xAxis.labelTextColor = UILabel.appearance.textColor;
    self.lineChart.leftAxis.labelTextColor = UILabel.appearance.textColor;
    
    [self updateChartData];
}

#pragma mark - Line Chart Functions

- (void)updateChartData {
    PFQuery *query = [PFQuery queryWithClassName:@"IntakeDayLog"];
    [query whereKey:@"user" equalTo:self.user];
    [query whereKey:@"createdAt" greaterThan:referenceDate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Unable to Load Chart Data"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            self.chartData = (NSMutableArray *)objects;
            
            IntakeDayLog *firstLog = self.chartData[0];
            NSDate *indexDate = referenceDate = [self getDateAtMidnight:firstLog.createdAt];

            for (int i = 0; i < self.chartData.count; i++) {
                int indx;
                IntakeDayLog *log = self.chartData[i];
                NSDate *midnightDate = [self getDateAtMidnight:log.createdAt];
                while (![midnightDate isEqualToDate:indexDate]) {
                    i++;
                    indx = [self getXCoordFromDate:indexDate];
                    [self.chartData insertObject:[IntakeDayLog new] atIndex:i];
                    indexDate = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:indexDate options:0];
                }
                indx = [self getXCoordFromDate:indexDate];
                indexDate = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:indexDate options:0];
            }
            
            self.lineChart.xAxis.axisMinimum = 0;
            self.lineChart.xAxis.axisMaximum = self.chartData.count;
            self.lineChart.xAxis.labelCount = self.chartData.count;
                                     
            [self reloadChart];
        }
    }];
}

- (void)reloadChart {
    if (self.chartData.count == 0) {
        return;
    }
    
    double lastValidLogGoal = 0;
    NSMutableArray<ChartDataEntry *> *goalDataEntries = [[NSMutableArray alloc] init];
    NSMutableArray<ChartDataEntry *> *achievedDataEntries = [[NSMutableArray alloc] init];
    NSMutableArray<UIColor *> *achievedColors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.chartData.count; i++) {
        IntakeDayLog *log = self.chartData[i];
        if (log.goal.doubleValue > 0) {
            lastValidLogGoal = log.goal.doubleValue;
        }
        double x = i;
        [goalDataEntries addObject:[[ChartDataEntry alloc] initWithX:x y:lastValidLogGoal]];
        [achievedDataEntries addObject:[[ChartDataEntry alloc] initWithX:x y:log.achieved.doubleValue icon:log.achieved.doubleValue >= lastValidLogGoal ? [[UIImage systemImageNamed:@"star.fill"] imageWithTintColor:[UIColor systemYellowColor]]: nil]];
        [achievedColors addObject:log.achieved.doubleValue >= lastValidLogGoal ? self.lineChart.backgroundColor : [UIColor lightGrayColor]];
    }
    
    LineChartDataSet *goalDataSet = [[LineChartDataSet alloc] initWithEntries:goalDataEntries];
    LineChartDataSet *achievedDataSet = [[LineChartDataSet alloc] initWithEntries:achievedDataEntries];

    goalDataSet.circleRadius = achievedDataSet.circleRadius = 6.0;
    goalDataSet.lineDashLengths = @[[NSNumber numberWithFloat:3.0f]];
    goalDataSet.colors = @[[UIColor mediumLightGray]];
    goalDataSet.circleColors = @[[UIColor mediumLightGray]];
    achievedDataSet.colors = @[[UIColor lightGrayColor]];
    achievedDataSet.circleColors = (NSArray *)achievedColors;
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:@[achievedDataSet, goalDataSet]];
    [data setDrawValues:NO];
    self.lineChart.data = data;
    self.lineChart.data.highlightEnabled = YES;
    
    [self.lineChart animateWithXAxisDuration:1 yAxisDuration:1.5 easingOption:ChartEasingOptionLinear];
}

#pragma mark - ChartAxisValueFormatter

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    return [dateFormatter stringFromDate:[NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:value toDate:referenceDate options:0]];
}

#pragma mark - Helper Functions

- (NSDate *)getDateAtMidnight:(NSDate *)date {
    return [NSCalendar.currentCalendar startOfDayForDate:date];
}

- (double)getXCoordFromDate:(NSDate *)date {
    NSDateComponents *diff = [NSCalendar.currentCalendar components:NSCalendarUnitDay fromDate:referenceDate toDate:date options:0];
    return diff.day;
}

/*
#pragma mark - ChartViewDelegate
 
- (void)didTapInfo:(UITapGestureRecognizer *)sender {
    NSString *title = @"";
    NSString *message = @"";
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle:title
                                                    message:message
                                                      image:nil
                                            buttonAlignment:UILayoutConstraintAxisHorizontal
                                            transitionStyle:PopupDialogTransitionStyleZoomIn
                                             preferredWidth:200
                                        tapGestureDismissal:YES
                                        panGestureDismissal:YES
                                              hideStatusBar:YES
                                                 completion:nil];
    [self presentViewController:popup animated:YES completion:nil];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
