//
//  ColorfulTheme.h
//  Bubbly
//
//  Created by Fiona Barry on 8/3/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Theme.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorfulTheme : NSObject <Theme>

- (instancetype)initWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
