//
//  DetailsViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Utilities.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) BOOL saved;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.recipe.name;
    [self.picture setImageWithURL:[NSURL URLWithString:self.recipe.picture.url]];
    self.websiteLabel.text = [NSString stringWithFormat:@"Website: %@", self.recipe.url];
    self.descriptionLabel.text = [NSString stringWithFormat:@"Description: %@", self.recipe.descriptionText];
    
    NSString *list = @"Ingredients: ";
    list = [list stringByAppendingString:self.recipe.ingredients[0]];
    for (int i = 1; i < self.recipe.ingredients.count; i++) {
        list = [list stringByAppendingString:@", "];
        list = [list stringByAppendingString:self.recipe.ingredients[i]];
    }
    
    self.ingredientsLabel.text = list;
    
    PFQuery *query = [self.recipe.savedBy query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"An Error Occured"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            NSString *userID = [User currentUser].objectId;
            for (User *user in objects) {
                if ([user.objectId isEqualToString:userID]) {
                    [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                    self.saved = YES;
                    break;
                }
            }
        }
    }];
}

- (IBAction)didTapSave:(id)sender {
    PFRelation *relation = [self.recipe relationForKey:@"savedBy"];
    if (self.saved) {
        [relation removeObject:[User currentUser]];
        [self.saveButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        self.saved = NO;
    } else {
        [relation addObject:[User currentUser]];
        [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        self.saved = YES;
    }
        
    [self.recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Unable to Update Save"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            self.saved = !self.saved;
            if (self.saved) {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
            } else {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
            }
        } else {
            NSLog(@"Saved");
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
