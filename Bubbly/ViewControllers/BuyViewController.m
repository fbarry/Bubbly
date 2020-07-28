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
#import "BuyCell.h"

@interface BuyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *ingredients;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BuyViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.allowsMultipleSelection = true;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.ingredients = [[NSMutableArray alloc] init];
    [self loadRecipes];
}

#pragma mark - API Calls

- (void)loadRecipes {
    PFQuery *query = [self.user.savedRecipes query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"An Error Occured"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            for (Recipe *recipe in objects) {
                for (NSString *ingredient in recipe.ingredients) {
                    if (![self.ingredients containsObject:ingredient]) {
                        [self.ingredients addObject:ingredient];
                    }
                }
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BuyCell"];
    cell.ingredientLabel.text = self.ingredients[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ingredients.count;
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
