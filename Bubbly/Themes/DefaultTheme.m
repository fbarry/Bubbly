//
//  DefaultTheme.m
//  Bubbly
//
//  Created by Fiona Barry on 7/29/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "DefaultTheme.h"

@implementation DefaultTheme

- (UIColor *)buttonTint {
    return [UIColor customBlue];
}

- (UIColor *)imageViewTint {
    return [UIColor darkGrayColor];
}

- (UIColor *)weatherIconBackground {
    return [UIColor customBlue];
}

- (UIColor *)labelText {
    return [UIColor blackColor];
}

- (UIColor *)titleLabelBackground {
    return [[UIColor customBlue] colorWithAlphaComponent:0.5];
}

- (UIColor *)selectedSegment {
    return [UIColor customBlue];
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
    return [UIColor lightCustomBlue];
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
