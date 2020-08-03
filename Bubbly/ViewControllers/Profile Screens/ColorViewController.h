//
//  ColorViewController.h
//  Bubbly
//
//  Created by Fiona Barry on 8/3/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ColorViewControllerDelegate <NSObject>

- (void)didSelectColor:(UIColor *)color;

@end

@interface ColorViewController : UIViewController

@property (strong, nonatomic) id<ColorViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
