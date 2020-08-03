//
//  ColorOptions.m
//  Bubbly
//
//  Created by Fiona Barry on 8/3/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "ThemeColorOptions.h"

@implementation ThemeColorOptions

+ (NSArray<UIColor *> *)getColorOptions {
    return @[[UIColor systemRedColor], [[UIColor systemRedColor] colorWithAlphaComponent:0.5], [UIColor systemOrangeColor], [[UIColor systemOrangeColor] colorWithAlphaComponent:0.5], [UIColor systemYellowColor], [[UIColor systemYellowColor] colorWithAlphaComponent:0.5], [UIColor systemGreenColor], [[UIColor systemGreenColor] colorWithAlphaComponent:0.5], [UIColor systemTealColor], [[UIColor systemTealColor] colorWithAlphaComponent:0.5], [UIColor systemBlueColor], [[UIColor systemBlueColor] colorWithAlphaComponent:0.5], [UIColor systemPurpleColor], [[UIColor systemPurpleColor] colorWithAlphaComponent:0.5], [UIColor systemIndigoColor], [[UIColor systemIndigoColor] colorWithAlphaComponent:0.5], [UIColor systemPinkColor], [[UIColor systemPinkColor] colorWithAlphaComponent:0.5], [UIColor systemGrayColor]];
}

@end
