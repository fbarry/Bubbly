//
//  LightTheme.m
//  Bubbly
//
//  Created by Fiona Barry on 7/30/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "LightTheme.h"

@implementation LightTheme

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
    return [UIColor blackColor];
}

- (UIColor *)titleLabelBackground {
    return [[UIColor customBlue] colorWithAlphaComponent:0.5];
}

- (UIColor *)selectedSegment {
    return [UIColor whiteColor];
}

- (UIColor *)fieldBackground {
    return [UIColor extraLightGray];
}

- (NSDictionary *)barButtonAttributes {
    return @{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next Condensed" size:20], NSForegroundColorAttributeName: [UIColor customBlue]};
}

- (NSDictionary *)navigationBarAttributes {
    return @{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next Condensed" size:20], NSForegroundColorAttributeName: [UIColor blackColor]};
}

- (UIColor *)barColor {
    return [UIColor extraLightGray];
}

- (UIColor *)viewColor {
    return [UIColor whiteColor];
}

- (UIColor *)shadow {
    return [UIColor extraLightGray];
}

//- (UIColor *)selectedCell {
//    return [UIColor extraLightGray];
//}


@end
