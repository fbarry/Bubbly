//
//  IngredientCell.m
//  Bubbly
//
//  Created by Fiona Barry on 7/14/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "IngredientCell.h"

@implementation IngredientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ingredient.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate didEndEditingCell:self withText:self.ingredient.text];
}

@end
