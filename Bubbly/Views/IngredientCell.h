//
//  IngredientCell.h
//  Bubbly
//
//  Created by Fiona Barry on 7/14/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IngredientCellDelegate <NSObject>

- (void)didEndEditingCell:(id)sender withText:(NSString *)ingredient;

@end

@interface IngredientCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) id <IngredientCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *ingredient;

@end

NS_ASSUME_NONNULL_END
