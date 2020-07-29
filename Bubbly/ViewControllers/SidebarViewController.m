//
//  SidebarViewController.m
//  Bubbly
//
//  Created by Fiona Barry on 7/23/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SidebarViewController.h"
#import "Utilities.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "User.h"
#import "SidebarCell.h"

static const int numOptions = 4;

@interface SidebarViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SidebarViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SidebarCell"];
    
    switch (indexPath.row) {
        case 0:
            [cell.button setTitle:@"Saved" forState:UIControlStateNormal];
            break;
        case 1:
            [cell.button setTitle:@"Ingredients" forState:UIControlStateNormal];
            break;
        case 2:
            [cell.button setTitle:@"Settings" forState:UIControlStateNormal];
            break;
        case 3:
            [cell.button setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
            [cell.button setTitle:@"Logout" forState:UIControlStateNormal];
            break;
        default:
            cell = nil;
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self.parentViewController performSegueWithIdentifier:@"Saved" sender:self];
            break;
        case 1:
            [self.parentViewController performSegueWithIdentifier:@"Buy" sender:self];
            break;
        case 2:
            [self.parentViewController performSegueWithIdentifier:@"Settings" sender:self];
            break;
        case 3:
            [Utilities presentConfirmationInViewController:self
                                                 withTitle:@"Are you sure you want to logout?"
                                                   message:nil
                                                yesHandler:^{
                SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
                sceneDelegate.window.rootViewController = welcomeViewController;

                [User logOut];
            }
                                                 noHandler:nil];
            break;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numOptions;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
