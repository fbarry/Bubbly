//
//  RecipeContainerViewController.h
//  Bubbly
//
//  Created by Fiona Barry on 7/31/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RecipeInformationDelegate <NSObject>

- (void)reloadData:(NSMutableArray *)recipes;

@end

@interface RecipeContainerViewController : UIViewController

@property (strong, nonatomic) id<RecipeInformationDelegate>gridDelegate;
@property (strong, nonatomic) id<RecipeInformationDelegate>listDelegate;

@end

NS_ASSUME_NONNULL_END
