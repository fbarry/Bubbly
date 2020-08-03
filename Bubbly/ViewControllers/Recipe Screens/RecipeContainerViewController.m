//
//  RecipeContainerViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/31/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "RecipeContainerViewController.h"
#import "RecipeGridViewController.h"
#import "RecipeListViewController.h"
#import "DetailsViewController.h"
#import "RecipeGridCell.h"
#import "RecipeListCell.h"
#import "Utilities.h"

@interface RecipeContainerViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (weak, nonatomic) IBOutlet UIView *listView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *closeKeyboard;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;
@property (strong, nonatomic) NSMutableArray *recipes;
@property (strong, nonatomic) NSMutableArray *filteredRecipes;

@end

@implementation RecipeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.searchBar.searchTextField.leftView.tintColor = UILabel.appearance.textColor;
    
    self.gridView.alpha = 1;
    self.listView.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.closeKeyboard setEnabled:NO];
    [self loadRecipes];
}

#pragma mark - Action Handlers

- (IBAction)didSelectSegment:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.swipeGesture.direction = NSLayoutAttributeRight;
            self.gridView.alpha = 1;
            self.listView.alpha = 0;
            self.gridView.userInteractionEnabled = YES;
            self.listView.userInteractionEnabled = NO;
            break;
        case 1:
            self.swipeGesture.direction = NSLayoutAttributeLeft;
            self.gridView.alpha = 0;
            self.listView.alpha = 1;
            self.gridView.userInteractionEnabled = NO;
            self.listView.userInteractionEnabled = YES;
            break;
    }
}

- (IBAction)didTapBackground:(id)sender {
    [self.closeKeyboard setEnabled:NO];
    [self.view endEditing:YES];
}

- (IBAction)didSwipe:(id)sender {
    self.segmentedControl.selectedSegmentIndex = (self.segmentedControl.selectedSegmentIndex + 1) % 2;
    [self didSelectSegment:self];
}

#pragma mark - API Calls

- (void)loadRecipes {
    PFQuery *query = [PFQuery queryWithClassName:@"Recipe"];
    [query includeKey:@"creator"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error loading recipes"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            self.recipes = (NSMutableArray *)objects;
            self.filteredRecipes = self.recipes;
            [self searchBar:self.searchBar textDidChange:self.searchBar.text];
        }
    }];
}

#pragma mark - Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.closeKeyboard setEnabled:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSArray *words = [searchText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            Recipe *recipe = (Recipe *)evaluatedObject;
            NSArray *ingredients = recipe.ingredients;
            NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@" argumentArray:words];
            if ([ingredients filteredArrayUsingPredicate:p].count > 0) {
                return YES;
            } else {
                return NO;
            }
        }];
        self.filteredRecipes = (NSMutableArray *)[self.recipes filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredRecipes = self.recipes;
    }
    
    [self.gridDelegate reloadData:self.filteredRecipes];
    [self.listDelegate reloadData:self.filteredRecipes];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Grid Embed"]) {
        RecipeGridViewController *gridViewController = [segue destinationViewController];
        self.gridDelegate = gridViewController;
    } else if ([segue.identifier isEqualToString:@"List Embed"]) {
        RecipeListViewController *listViewController = [segue destinationViewController];
        self.listDelegate = listViewController;
    } else if ([segue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.recipe = sender;
    }
}

@end
