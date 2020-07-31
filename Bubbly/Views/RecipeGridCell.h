//
//  RecipeCell.h
//  Bubbly
//
//  Created by Fiona Barry on 7/14/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeGridCell : UICollectionViewCell

@property (strong, nonatomic) Recipe *recipe;

- (void)setProperties;

@end

NS_ASSUME_NONNULL_END
