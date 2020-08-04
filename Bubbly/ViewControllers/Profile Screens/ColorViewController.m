//
//  ColorViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 8/3/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "ColorViewController.h"
#import "ThemeColorOptions.h"
#import "ColorCell.h"
#import "Utilities.h"

@interface ColorViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.frame = self.view.frame;
    self.collectionView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    
    CGFloat postersPerRow = 4;
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right - layout.minimumInteritemSpacing * (postersPerRow - 1)) / postersPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.collectionView.allowsSelection = YES;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
    cell.color = [ThemeColorOptions getColorOptions][indexPath.item];
    [cell setProperties];
    [cell selected];
    [cell deselected];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ThemeColorOptions getColorOptions].count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorCell *tappedCell = (ColorCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [tappedCell selected];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorCell *tappedCell = (ColorCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [tappedCell deselected];
}

- (IBAction)didTapDone:(id)sender {
    if (self.collectionView.indexPathsForSelectedItems.count == 0) {
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Select an accent color"
                                                    message:nil];
    } else {
        [self.delegate didSelectColor:[ThemeColorOptions getColorOptions][self.collectionView.indexPathsForSelectedItems[0].item]];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
