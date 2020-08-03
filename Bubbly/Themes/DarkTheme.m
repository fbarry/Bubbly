//
//  DarkTheme.m
//  Bubbly
//
//  Created by Fiona Barry on 7/30/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "DarkTheme.h"

@implementation DarkTheme

- (UIColor *)buttonTint {
    return [UIColor customBlue];
}

- (UIColor *)imageViewTint {
    return [UIColor lightGrayColor];
}

- (UIColor *)weatherIconBackground {
    return [UIColor lightGrayColor];
}

- (UIColor *)labelText {
    return [UIColor whiteColor];
}

- (UIColor *)titleLabelBackground {
    return [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
}

- (UIColor *)selectedSegment {
    return [UIColor lightGrayColor];
}

- (UIColor *)fieldBackground {
    return [UIColor lightGrayColor];
}

- (NSDictionary *)barButtonAttributes {
    return @{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next Condensed" size:20], NSForegroundColorAttributeName: [UIColor customBlue]};
}

- (NSDictionary *)navigationBarAttributes {
    return @{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next Condensed" size:20], NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (UIColor *)barColor {
    return [UIColor darkGrayColor];
}

- (UIColor *)viewColor {
    return [UIColor blackColor];
}

- (UIColor *)shadow {
    return [UIColor extraLightGray];
}

@end
