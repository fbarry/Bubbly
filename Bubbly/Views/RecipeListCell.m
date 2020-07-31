//
//  RecipeListCell.m
//  Bubbly
//
//  Created by Fiona Barry on 7/31/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "RecipeListCell.h"
#import <UIImageView+AFNetworking.h>

@interface RecipeListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation RecipeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProperties {
    self.picture.layer.cornerRadius = 16;
    self.picture.layer.masksToBounds = YES;
    
    [self.picture setImageWithURL:[NSURL URLWithString:self.recipe.picture.url]];
    self.nameLabel.text = self.recipe.name;
    self.creatorLabel.text = self.recipe.creator.name;
    self.descriptionLabel.text = self.recipe.descriptionText && self.recipe.descriptionText.length > 0 ? self.recipe.descriptionText : @"";
}

@end
