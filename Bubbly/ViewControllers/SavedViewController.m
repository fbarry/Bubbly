//
//  SavedViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/15/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SavedViewController.h"
#import "Recipe.h"
#import "RecipeCell.h"
#import "UIImageView+AFNetworking.h"
#import "Utilities.h"

@interface SavedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *recipes;

@end

@implementation SavedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.frame = self.view.frame;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerRow = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerRow - 1)) / postersPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.recipes = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadRecipes];
}

- (void)loadRecipes {
    PFQuery *query = [PFQuery queryWithClassName:@"Recipe"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Could not load saved recipes"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            for (Recipe *recipe in objects) {
                PFRelation *relation = [recipe relationForKey:@"savedBy"];
                PFQuery *relationQuery = [relation query];
                [relationQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    if (error) {
                        [Utilities presentOkAlertControllerInViewController:self
                                                                  withTitle:@"Could not load saved recipes"
                                                                    message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
                    } else {
                        NSString *userID = [User currentUser].objectId;
                        for (User *user in objects) {
                            if ([user.objectId isEqualToString:userID]) {
                                [self.recipes addObject:recipe];
                                break;
                            }
                        }
                    }
                    [self.collectionView reloadData];
                }];
            }
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecipeCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RecipeCell" forIndexPath:indexPath];
    cell.recipe = self.recipes[indexPath.item];
    cell.nameLabel.text = cell.recipe.name;
    [cell.recipePicture setImage:[UIImage systemImageNamed:@"book"]];
    
    if (cell.recipe.picture) {
        [cell.recipePicture setImageWithURL:[NSURL URLWithString:cell.recipe.picture.url]];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
