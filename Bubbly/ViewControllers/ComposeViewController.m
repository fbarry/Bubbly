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

@interface ComposeViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CameraViewDelegate, IngredientCellDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *recipePicture;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *URLField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic) NSMutableArray *ingredients;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.descriptionField.delegate = self;
    
    self.ingredients = [[NSMutableArray alloc] init];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboard = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboard.size.height;
    self.scrollView.contentInset = contentInset;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInset;
}


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

- (IBAction)didTapAdd:(id)sender {
    [self.ingredients insertObject:@"" atIndex:self.ingredients.count];
    [self.tableView reloadData];
}

- (void)didEndEditingCell:(id)sender withText:(NSString *)ingredient {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    self.ingredients[indexPath.row] = ingredient;
}

- (IBAction)didTapPicture:(id)sender {
    CameraView *camera = [[CameraView alloc] init];
    camera.viewController = self;
    camera.delegate = self;
    [camera alertConfirmation];
}

- (void)setImage:(nonnull UIImage *)image withName:(nonnull NSString *)name {
    [self.recipePicture setImage:image forState:UIControlStateNormal];
}

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

- (IBAction)didTapPost:(id)sender {
    if ([self invalidInput]) {
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Invalid Input"
                                                    message:@"One or more required fields are empty"];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        Recipe *recipe = [Recipe new];
        
        recipe.creator = [User currentUser];
        recipe.name = self.nameField.text;
        recipe.ingredients = self.ingredients;
        
        if (![self.descriptionField.text isEqualToString:@"Description (Optional)"]) {
            recipe.descriptionText = self.descriptionField.text;
        }
        
        recipe.picture = [Utilities getPFFileFromImage:self.recipePicture.imageView.image];
        recipe.url = self.URLField.text;
        
        [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"Error posting recipe"
                                                            message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate didPost:recipe];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (BOOL)invalidInput {    
    [self.ingredients removeObjectIdenticalTo:@""];
    [self.tableView reloadData];
    return [self.nameField.text isEqual:@""] || self.ingredients.count == 0;
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
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
