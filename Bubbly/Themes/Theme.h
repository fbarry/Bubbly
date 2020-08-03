//
//  Theme.h
//  Bubbly
//
//  Created by Fiona Barry on 7/29/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ColorExtensions.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    DEFAULT,
    LIGHT,
    DARK,
    COLORFUL,
} ThemeName;

@protocol Theme <NSObject>

@property (readonly) UIColor *buttonTint;
@property (readonly) UIColor *imageViewTint;
@property (readonly) UIColor *weatherIconBackground;
@property (readonly) UIColor *labelText;
@property (readonly) UIColor *titleLabelBackground;
@property (readonly) UIColor *selectedSegment;
@property (readonly) UIColor *fieldBackground;
@property (readonly) NSDictionary *barButtonAttributes;
@property (readonly) NSDictionary *navigationBarAttributes;
@property (readonly) UIColor *barColor;
@property (readonly) UIColor *viewColor;
@property (readonly) UIColor *shadow;

@end

NS_ASSUME_NONNULL_END
