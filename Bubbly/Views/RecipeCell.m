//
//  RecipeCell.m
//  Bubbly
//
//  Created by Fiona Barry on 7/14/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "RecipeCell.h"
#import <UIImageView+AFNetworking.h>

@interface RecipeCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipePicture;

@end

@implementation RecipeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setProperties {
    self.nameLabel.text = self.recipe.name;
    [self.recipePicture setImageWithURL:[NSURL URLWithString:self.recipe.picture.url] placeholderImage:[UIImage systemImageNamed:@"book"]];
}

@end
