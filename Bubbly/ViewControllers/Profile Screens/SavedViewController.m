//
//  SavedViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/15/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SavedViewController.h"
#import "Recipe.h"
#import "RecipeGridCell.h"
#import "UIImageView+AFNetworking.h"
#import "Utilities.h"
#import "ProfileContainerViewController.h"
#import "DetailsViewController.h"

@interface SavedViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SidebarStatusDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *recipes;

@end

@implementation SavedViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.frame = self.view.frame;
    self.collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    
    CGFloat postersPerRow = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right - layout.minimumInteritemSpacing * (postersPerRow - 1)) / postersPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadRecipes];
}

#pragma mark - API Calls

- (void)loadRecipes {
    PFQuery *query = [PFQuery new];
    
    if ([self.restorationIdentifier isEqualToString:@"Saved"]) {
        query = [self.user.savedRecipes query];
    } else {
        query = [Recipe query];
        [query whereKey:@"creator" equalTo:self.user];
    }
    
    [query includeKey:@"creator"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"An Error Occured"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            self.recipes = objects;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - CollectionViewDelegate & DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.restorationIdentifier isEqualToString:@"Custom"]) {
        [self.parentViewController.parentViewController performSegueWithIdentifier:@"Details" sender:self.recipes[indexPath.item]];
    } else {
        [self performSegueWithIdentifier:@"Details" sender:self.recipes[indexPath.item]];
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecipeGridCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RecipeGridCell" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height / 16;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = UIView.appearance.tintColor.CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 4.0f);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    cell.recipe = self.recipes[indexPath.item];
    [cell setProperties];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recipes.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.recipe = sender;
    }
}

@end
