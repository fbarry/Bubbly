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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate didEndEditingCell:self withText:self.ingredient.text];
}

@end
