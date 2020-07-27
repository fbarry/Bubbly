//
//  BrowseViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "RecipesViewController.h"
#import "DetailsViewController.h"
#import "RecipeCell.h"
#import "Recipe.h"
#import "Utilities.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"

@interface RecipesViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *recipes;
@property (strong, nonatomic) NSMutableArray *filteredRecipes;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *closeKeyboard;

@end

@implementation RecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.searchBar.delegate = self;
     
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView.refreshControl addTarget:self action:@selector(loadRecipes) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.frame = self.view.frame;
    self.collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    
    CGFloat postersPerRow = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right - layout.minimumInteritemSpacing * (postersPerRow - 1)) / postersPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self.closeKeyboard setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadRecipes];
}

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
            [self.collectionView reloadData];
        }
        [self.collectionView.refreshControl endRefreshing];
    }];
}

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
    
    [self.collectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecipeCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RecipeCell" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height / 16;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 4.0f);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    cell.recipe = self.filteredRecipes[indexPath.item];
    cell.nameLabel.text = cell.recipe.name;
    [cell.recipePicture setImage:[UIImage systemImageNamed:@"book"]];
    
    if (cell.recipe.picture) {
        [cell.recipePicture setImageWithURL:[NSURL URLWithString:cell.recipe.picture.url]];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredRecipes.count;
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
    [self.closeKeyboard setEnabled:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        RecipeCell *tappedCell = sender;
        detailsViewController.recipe = tappedCell.recipe;
    }
}

@end
