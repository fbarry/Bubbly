//
//  ColorCell.h
//  Bubbly
//
//  Created by Fiona Barry on 8/3/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorCell : UICollectionViewCell

@property (strong, nonatomic) UIColor *color;

- (void)setProperties;
- (void)selected;
- (void)deselected;

@end

NS_ASSUME_NONNULL_END
