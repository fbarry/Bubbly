//
//  HomeViewController.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "IntakeDayLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (strong, nonatomic) IntakeDayLog *dayLog;
@property (strong, nonatomic) User *user;

- (void)createNewLog;

@end

NS_ASSUME_NONNULL_END
