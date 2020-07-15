//
//  BuyViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/15/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "BuyViewController.h"
#import "Recipe.h"
#import "Utilities.h"

@interface BuyViewController ()

@property (strong, nonatomic) NSMutableSet *ingredients;

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.ingredients = [[NSMutableSet alloc] init];
    [self loadRecipes];
}

- (void)loadRecipes {
    PFQuery *query = [[User currentUser].savedRecipes query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"An Error Occured"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            for (Recipe *recipe in objects) {
                [self.ingredients addObjectsFromArray:recipe.ingredients];
            }
            NSLog(@"%@", self.ingredients);
            // reload
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
