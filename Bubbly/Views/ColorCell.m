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

- (void)selected {
    [UIView animateWithDuration:0.3 animations:^{
        self.circle.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
}

- (void)deselected {
    [UIView animateWithDuration:0.3 animations:^{
        self.circle.transform = CGAffineTransformMakeScale(1.0/1.1, 1.0/1.1);
    }];
}

@end
