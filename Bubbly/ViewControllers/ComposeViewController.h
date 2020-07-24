//
//  ComposeViewController.h
//  Bubbly
//
//  Created by Fiona Barry on 7/14/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate <NSObject>

- (void)didPost:(Recipe *)recipe;

@end

@interface ComposeViewController : UIViewController

@property (strong, nonatomic) id <ComposeViewControllerDelegate> delegate;
@property (strong, nonatomic) Recipe *recipe;

@end

NS_ASSUME_NONNULL_END
