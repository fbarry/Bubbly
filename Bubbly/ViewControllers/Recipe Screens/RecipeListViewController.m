//
//  RecipeListViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/31/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "RecipeListViewController.h"
#import "RecipeListCell.h"

@interface RecipeListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *recipes;

@end

@implementation RecipeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.frame = self.view.frame;    
}

#pragma mark - RecipeInformationDelegate

- (void)reloadData:(NSMutableArray *)recipes {
    self.recipes = recipes;
    [self.tableView reloadData];
}

#pragma mark - TableViewDataSource & Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.parentViewController performSegueWithIdentifier:@"Details" sender:self.recipes[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeListCell"];
    
    cell.recipe = self.recipes[indexPath.row];
    [cell setProperties];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
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
