//
//  BrowseViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "BrowseViewController.h"
#import "DetailsViewController.h"
#import "RecipeCell.h"
#import "Recipe.h"
#import "Utilities.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"

@interface BrowseViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *recipes;
@property (strong, nonatomic) NSMutableArray *filteredRecipes;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *closeKeyboard;

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.searchBar.delegate = self;
     
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView.refreshControl addTarget:self action:@selector(loadRecipes) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.frame = self.view.frame;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerRow = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerRow - 1)) / postersPerRow;
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
            [self.collectionView reloadData];
        }
        [self.collectionView.refreshControl endRefreshing];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.closeKeyboard setEnabled:YES];
    
    NSArray *words = [searchText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ingredients contains[c] %@" argumentArray:words];
        self.filteredRecipes = (NSMutableArray *)[self.recipes filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredRecipes = self.recipes;
    }
    
    [self.collectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecipeCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RecipeCell" forIndexPath:indexPath];
    cell.recipe = self.filteredRecipes[indexPath.item];
    cell.nameLabel.text = cell.recipe.name;
    [cell.recipePicture setImage:[UIImage systemImageNamed:@"book"]];
    
    [cell.activityIndicator startAnimating];
    if (cell.recipe.picture) {
        [cell.recipePicture setImageWithURL:[NSURL URLWithString:cell.recipe.picture.url]];
    }
    [cell.activityIndicator stopAnimating];
    
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
