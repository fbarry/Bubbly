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
#import "Utilities.h"

@interface DataViewController () <IChartAxisValueFormatter>

@property (strong, nonatomic) IBOutlet LineChartView *lineChart;
@property (strong, nonatomic) NSArray *chartData;

@end

@implementation DataViewController

NSDate *referenceDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.lineChart.chartDescription setEnabled:NO];
    [self.lineChart.rightAxis setEnabled:NO];
    [self.lineChart.legend setEnabled:NO];
    
    referenceDate = [self getDateAtMidnight:[NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:-20 toDate:[NSDate date] options:0]];
        
    ChartXAxis *xAxis = self.lineChart.xAxis;
    xAxis.valueFormatter = self;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelCount = 20;
    xAxis.granularity = 1.0;
    xAxis.labelRotationAngle = -45;
    
    ChartYAxis *yAxis = self.lineChart.leftAxis;
    yAxis.axisMinimum = 0;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    return [dateFormatter stringFromDate:[NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:value toDate:referenceDate options:0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self updateChartData];
}

- (void)updateChartData {
    PFQuery *query = [PFQuery queryWithClassName:@"IntakeLog"];
    [query whereKey:@"user" equalTo:[User currentUser]];
    [query whereKey:@"createdAt" greaterThan:referenceDate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Unable to Load Chart Data"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            self.chartData = objects;
            [self reloadChart];
        }
    }];
}

- (NSDate *)getDateAtMidnight:(NSDate *)date {
    return [NSCalendar.currentCalendar startOfDayForDate:date];
}

- (void)reloadChart {
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] init];
    NSDate *indexDate = referenceDate;
    for (IntakeLog *log in self.chartData) {
        BOOL err = NO;
        double x, y;
        NSDate *midnightDate = [self getDateAtMidnight:log.createdAt];
        while (![midnightDate isEqualToDate:indexDate]) {
            x = [self getXCoordFromDate:indexDate];
            y = 0;
            ChartDataEntry *dataEntry = [[ChartDataEntry alloc] initWithX:x y:y];
            if (![dataSet addEntryOrdered:dataEntry]) {
                err = YES;
                break;
            }
            indexDate = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:indexDate options:0];
        }
        x = [self getXCoordFromDate:midnightDate];
        y = [log.achieved doubleValue];
        ChartDataEntry *dataEntry = [[ChartDataEntry alloc] initWithX:x y:y];
        if (err || ![dataSet addEntryOrdered:dataEntry]) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error Building Data"
                                                        message:@"Re-enter page to try again"];
            break;
        }
        indexDate = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:indexDate options:0];
    }
    
    LineChartData *data = [[LineChartData alloc] initWithDataSet:dataSet];
    self.lineChart.data = data;
    [self.lineChart.data setDrawValues:NO];
    
    [self.lineChart animateWithXAxisDuration:1 yAxisDuration:1.5 easingOption:ChartEasingOptionLinear];
}

- (double)getXCoordFromDate:(NSDate *)date {
    NSDateComponents *diff = [NSCalendar.currentCalendar components:NSCalendarUnitDay fromDate:referenceDate toDate:date options:0];
    return diff.day;
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
