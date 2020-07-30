//
//  DetailsViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Utilities.h"
#import "ProfileContainerViewController.h"
#import "ComposeViewController.h"
#import "FacebookShareView.h"
#import "SaveButton.h"

@interface DetailsViewController () <ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;
@property (weak, nonatomic) IBOutlet SaveButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *creatorName;
@property (weak, nonatomic) IBOutlet UILabel *updatedDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) User *user;
@property (nonatomic) BOOL saved;

@end

@implementation DetailsViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [User currentUser];
    
    if (![self.recipe.creator.objectId isEqual:self.user.objectId]) {
        self.navigationItem.rightBarButtonItems = @[self.saveButton];
    }
    
    self.nameLabel.layer.cornerRadius = 16;
    self.nameLabel.clipsToBounds = YES;
    
    [Utilities roundImage:self.profilePicture];
    
    [self.profilePicture setImageWithURL:[NSURL URLWithString:self.recipe.creator.profilePicture.url]];
    UITapGestureRecognizer *profileTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCreator:)];
    [self.profilePicture addGestureRecognizer:profileTapGesture];
    
    [self.creatorName setTitle:self.recipe.creator.name forState:UIControlStateNormal];
            
    PFQuery *query = [self.user.savedRecipes query];
    [query whereKey:@"objectId" equalTo:self.recipe.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"An Error Occured"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            if (objects.count > 0) {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"]];
                self.saved = YES;
            } else {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart"]];
                self.saved = NO;
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.nameLabel.text = self.recipe.name;
    [self.picture setImageWithURL:[NSURL URLWithString:self.recipe.picture.url]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM, YYYY 'at' h:mm a zzz"];
    self.updatedDate.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:self.recipe.updatedAt]];
    
    self.websiteLabel.text = [NSString stringWithFormat:@"Website: %@", self.recipe.url && self.recipe.url.length > 0 ? self.recipe.url : @"Not Available"];
    self.descriptionLabel.text = [NSString stringWithFormat:@"Description: %@", self.recipe.descriptionText && self.recipe.descriptionText.length > 0 ? self.recipe.descriptionText : @"Not Available"];
    
    NSString *joinedString = [self.recipe.ingredients componentsJoinedByString:@", "];
    self.ingredientsLabel.text = [@"Ingredients: " stringByAppendingString:joinedString];
}

#pragma mark - Action Handlers

- (IBAction)didTapSave:(id)sender {
    PFRelation *relation = [self.recipe relationForKey:@"savedBy"];
    PFRelation *relation2 = [self.user relationForKey:@"savedRecipes"];
        
    if (self.saved) {
        [relation removeObject:self.user];
        [relation2 removeObject:self.recipe];
        [self.saveButton setImage:[UIImage systemImageNamed:@"heart"]];
        self.saved = NO;
    } else {
        [relation addObject:self.user];
        [relation2 addObject:self.recipe];
        [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"]];
        self.saved = YES;
    }
        
    [self.recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Unable to Update Save"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            self.saved = !self.saved;
            if (!self.saved) {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart"]];
            } else {
                [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"]];
            }
        } else {
            [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    [Utilities presentOkAlertControllerInViewController:self
                                                              withTitle:@"Unable to Update Save"
                                                                message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
                    self.saved = !self.saved;
                    if (!self.saved) {
                        [self.saveButton setImage:[UIImage systemImageNamed:@"heart"]];
                    } else {
                        [self.saveButton setImage:[UIImage systemImageNamed:@"heart.fill"]];
                    }
                } else {
                    NSLog(@"Saved");
                }
            }];
        }
    }];
}

- (IBAction)didTapShare:(id)sender {
    FacebookShareView *share = [[FacebookShareView alloc] initWithTitle:@"Would you like to share this recipe to Facebook?"
                                                                 photos:@[self.picture.image]
                                                       inViewController:self];
    [share presentShareView];
}

- (IBAction)didTapEdit:(id)sender {
    [self performSegueWithIdentifier:@"Edit" sender:self];
}

- (IBAction)didTapCreator:(id)sender {
    [self performSegueWithIdentifier:@"Profile" sender:self];
}

#pragma mark - ComposeViewControllerDelegate

- (void)didDelete {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Profile"]) {
        ProfileContainerViewController *profileContainerViewController = [segue destinationViewController];
        profileContainerViewController.user = self.recipe.creator;
    } else if ([segue.identifier isEqualToString:@"Edit"]) {
        ComposeViewController *composeViewController = [segue destinationViewController];
        composeViewController.recipe = self.recipe;
        composeViewController.delegate = self;
    }
}

@end
