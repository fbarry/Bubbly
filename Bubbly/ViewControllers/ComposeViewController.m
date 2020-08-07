//
//  ComposeViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/14/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "ComposeViewController.h"
#import "IngredientCell.h"
#import "Utilities.h"
#import "CameraView.h"
#import "Recipe.h"
#import "User.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface ComposeViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CameraViewDelegate, IngredientCellDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *recipePicture;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *URLField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) NSMutableArray *ingredients;

@end

@implementation ComposeViewController

BOOL newRecipe = NO;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.descriptionField.delegate = self;
    
    self.deleteButton.layer.cornerRadius = 16;
    
    self.ingredients = [[NSMutableArray alloc] init];
    [self.ingredients addObject:@""];
    
    if (!self.recipe) {
        self.recipe = [Recipe new];
        [self.deleteButton removeFromSuperview];
        newRecipe = YES;
    } else {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImageWithURL:[NSURL URLWithString:self.recipe.picture.url]];
        [self.recipePicture setImage:imageView.image forState:UIControlStateNormal];
        self.nameField.text = self.recipe.name;
        self.ingredients = (NSMutableArray *)self.recipe.ingredients;
        if (self.recipe.url.length > 0) {
            self.URLField.text = self.recipe.url;
        }
        if (self.recipe.descriptionText.length > 0) {
            self.descriptionField.text = self.recipe.descriptionText;
        }
    }
}

#pragma mark - TableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    IngredientCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"IngredientCell"];
    cell.delegate = self;
    cell.ingredient.text = nil;
    if (![self.ingredients[indexPath.row] isEqual:@""]) {
        cell.ingredient.text = self.ingredients[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ingredients.count;
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    for (int i = 0; i < self.ingredients.count; i++) {
        IngredientCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.ingredient.text isEqualToString:@""]) {
            return YES;
        }
    }
    [self didTapAdd:self];
    return YES;
}

#pragma mark - IngredientCellDelegate

- (void)didEndEditingCell:(id)sender withText:(NSString *)ingredient {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    self.ingredients[indexPath.row] = ingredient;
    for (int i = 0; i < self.ingredients.count; i++) {
        IngredientCell *cell = sender;
        if ([cell.ingredient.text isEqualToString:@""]) {
            return;
        }
    }
    [self didTapAdd:self];
}

#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.descriptionField.text isEqualToString:@"Description (Optional)"]) {
        self.descriptionField.text = nil;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.descriptionField.text isEqual:@""]) {
        self.descriptionField.text = @"Description (Optional)";
    }
}

#pragma mark - Action Handlers

- (IBAction)didTapAdd:(id)sender {
    [self.ingredients insertObject:@"" atIndex:self.ingredients.count];
    [self.tableView reloadData];
}

- (IBAction)didTapPicture:(id)sender {
    CameraView *camera = [[CameraView alloc] init];
    camera.viewController = self;
    camera.delegate = self;
    [camera alertConfirmation];
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapPost:(id)sender {
    if ([self invalidInput]) {
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Invalid Input"
                                                    message:@"One or more required fields are empty"];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
        self.recipe.creator = [User currentUser];
        self.recipe.name = self.nameField.text;
        self.recipe.ingredients = self.ingredients;
        self.recipe.descriptionText = [self.descriptionField.text isEqualToString:@"Description (Optional)"] ? @"" : self.descriptionField.text;
        self.recipe.picture = [Utilities getPFFileFromImage:self.recipePicture.imageView.image];
        self.recipe.url = self.URLField.text;
        
        [self.recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"Error posting recipe"
                                                            message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (IBAction)didTapDelete:(id)sender {
    [Utilities presentConfirmationInViewController:self
                                         withTitle:@"Are you sure you want to delete this recipe?"
                                           message:@"This action cannot be undone"
                                             image:nil
                                        yesHandler:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.recipe deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"Could not delete recipe"
                                                            message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            } else {
                [self.delegate didDelete];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
                                         noHandler:nil];
}

#pragma mark - Helper Functions

- (BOOL)invalidInput {    
    [self.ingredients removeObjectIdenticalTo:@""];
    [self.tableView reloadData];
    return [self.nameField.text isEqual:@""] || self.ingredients.count == 0;
}

- (void)setImage:(nonnull UIImage *)image withName:(nonnull NSString *)name {
    [self.recipePicture setImage:image forState:UIControlStateNormal];
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
