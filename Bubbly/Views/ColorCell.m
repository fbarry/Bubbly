//
//  ColorCell.m
//  Bubbly
//
//  Created by Fiona Barry on 8/3/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "ColorCell.h"

@interface ColorCell ()

@property (weak, nonatomic) IBOutlet UIImageView *circle;

@end

@implementation ColorCell

- (void)setProperties {
    self.circle.tintColor = self.color;
}

@end
