//
//  ColorfulTheme.m
//  Bubbly
//
//  Created by Fiona Barry on 8/3/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "ColorfulTheme.h"
#import "Utilities.h"

@interface ColorfulTheme ()

@property (strong, nonatomic) UIColor *accent;

@end

@implementation ColorfulTheme

- (instancetype)initWithColor:(UIColor *)color {
    self = [super init];
    self.accent = color;
    return self;
}

- (UIColor *)buttonTint {
    return self.accent;
}

- (UIColor *)imageViewTint {
    return [UIColor darkGrayColor];
}

- (UIColor *)weatherIconBackground {
    return [self.accent colorWithAlphaComponent:1];
}

- (UIColor *)labelText {
    return [UIColor blackColor];
}

- (UIColor *)titleLabelBackground {
    return [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
}

- (UIColor *)selectedSegment {
    return self.accent;
}

- (UIColor *)fieldBackground {
    return [UIColor extraLightGray];
}

- (NSDictionary *)barButtonAttributes {
    return @{NSFontAttributeName : [UIFont fontWithName:@"Avenir Next Condensed" size:20], NSForegroundColorAttributeName: self.accent};
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
    return self.accent;
}

@end
