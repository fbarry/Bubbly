//
//  UIColor+ColorExtensions.m
//  Bubbly
//
//  Created by Fiona Barry on 7/29/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "UIColor+ColorExtensions.h"

@implementation UIColor (ColorExtensions)

+ (UIColor *)customBlue {
    return [UIColor colorWithRed:116.0/255.0 green:202.0/255.0 blue:234.0/255.0 alpha:1];
}

+ (UIColor *)lightCustomBlue {
    return [UIColor colorWithRed:231.0/255.0 green:244.0/255.0 blue:249.0/255.0 alpha:1];
}

+ (UIColor *)extraLightGray {
    return [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:247.0/255.0 alpha:1];
}

+ (UIColor *)mediumLightGray {
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
}

@end
