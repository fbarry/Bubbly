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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) User *user;
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
    
    self.user = [User currentUser];
    
    PFQuery *query = [self.user.savedRecipes query];
    [query whereKey:@"objectId" equalTo:self.recipe.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"An Error Occured"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            if (objects.count > 0) {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"]];
                self.saved = YES;
            } else {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart"]];
                self.saved = NO;
            }
        }
    }];
}

- (IBAction)didTapSave:(id)sender {
    PFRelation *relation = [self.recipe relationForKey:@"savedBy"];
    PFRelation *relation2 = [self.user relationForKey:@"savedRecipes"];
        
    if (self.saved) {
        [relation removeObject:self.user];
        [relation2 removeObject:self.recipe];
        [self.saveButton setImage:[UIImage systemImageNamed:@"heart"]];
        self.saved = NO;
    } else {
        [relation addObject:self.user];
        [relation2 addObject:self.recipe];
        [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"]];
        self.saved = YES;
    }
        
    [self.recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Unable to Update Save"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            self.saved = !self.saved;
            if (!self.saved) {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart"]];
            } else {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"]];
            }
        } else {
            [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    [Utilities presentOkAlertControllerInViewController:self
                                                              withTitle:@"Unable to Update Save"
                                                                message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
                    self.saved = !self.saved;
                    if (!self.saved) {
                        [self.saveButton setImage:[UIImage systemImageNamed:@"heart"]];
                    } else {
                        [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"]];
                    }
                } else {
                    NSLog(@"Saved");
                }
            }];
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
