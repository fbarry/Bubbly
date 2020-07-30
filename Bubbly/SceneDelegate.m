//
//  SceneDelegate.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SceneDelegate.h"
#import "User.h"
#import <FBSDKCoreKit.h>
#import <FBSDKLoginKit.h>
#import "Theme.h"
#import "DefaultTheme.h"
#import "WeatherIcon.h"
#import "BackgroundView.h"
#import "TitleLabel.h"
#import "SaveButton.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <PopupDialog-Swift.h>
#import "LightTheme.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    [self applyTheme:[[DefaultTheme alloc] init]];
    
    User *user = [User currentUser];
    if (user) {
        NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
        [center addObserver:self selector:@selector(didChangeTheme:) name:@"ThemeChangedEvent" object:nil];
        
        // Change to user selected theme
        NSNotification *newTheme = [[NSNotification alloc] initWithName:@"ThemeChangedEvent" object:nil userInfo:@{@"ThemeName" : [NSNumber numberWithInt:0]}];
        [NSNotificationCenter.defaultCenter postNotification:newTheme];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *tabBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        self.window.rootViewController = tabBarViewController;
    }
}

- (void)didChangeTheme:(NSNotification *)notification {
    NSNumber *enumVal = notification.userInfo[@"ThemeName"];
    ThemeName themeName = enumVal.intValue;
    
    id<Theme>theme = [self getThemeByName:themeName];
    [self applyTheme:theme];
}

- (id<Theme>) getThemeByName:(ThemeName)name {
    switch (name) {
        case DEFAULT:
            return [[DefaultTheme alloc] init];
        case LIGHT:
            return [[LightTheme alloc] init];
        case DARK:
            break;
    }
    return [[DefaultTheme alloc] init];
}

- (void)applyTheme:(id<Theme>)theme {
    UIButton.appearance.tintColor = theme.buttonTint;
        
    PopupDialogButton.appearance.titleColor = theme.buttonTint;
    PopupDialogButton.appearance.titleFont = theme.barButtonAttributes[NSFontAttributeName];
    PopupDialogDefaultView.appearance.titleFont = theme.barButtonAttributes[NSFontAttributeName];
    PopupDialogDefaultView.appearance.messageFont = theme.barButtonAttributes[NSFontAttributeName];
    
    UIImageView.appearance.tintColor = theme.imageViewTint;
    [UIImageView appearanceWhenContainedInInstancesOfClasses:@[[FBSDKLoginButton class]]].tintColor = [UIColor clearColor];
    
    WeatherIcon.appearance.backgroundColor = theme.weatherIconBackground;
    
    UILabel.appearance.textColor = theme.labelText;
    
    TitleLabel.appearance.backgroundColor = theme.titleLabelBackground;
    
    UITextField.appearance.textColor = theme.labelText;
    UITextField.appearance.backgroundColor = theme.fieldBackground;
    
    UITextView.appearance.textColor = theme.labelText;
    UITextView.appearance.backgroundColor = theme.fieldBackground;
    
    UISegmentedControl.appearance.selectedSegmentTintColor = theme.selectedSegment;
    
    [UIBarButtonItem.appearance setTitleTextAttributes:theme.barButtonAttributes forState:UIControlStateNormal];
    
    SaveButton.appearance.tintColor = [UIColor redColor];
    
    [UINavigationBar.appearance setTitleTextAttributes:theme.navigationBarAttributes];
    UINavigationBar.appearance.barTintColor = theme.barColor;
    
    UITabBar.appearance.barTintColor = theme.barColor;
    UITabBar.appearance.tintColor = theme.buttonTint;
    
    BackgroundView.appearance.backgroundColor = theme.viewColor;
    
    UICollectionView.appearance.backgroundColor = theme.viewColor;
    UICollectionViewCell.appearance.backgroundColor = theme.viewColor;
    
    UITableView.appearance.backgroundColor = theme.viewColor;
    UITableViewCell.appearance.backgroundColor = theme.viewColor;
    
    UISearchBar.appearance.tintColor = theme.labelText;
    UISearchBar.appearance.barTintColor = theme.viewColor;
    
    UIView.appearance.layer.shadowColor = theme.shadow.CGColor;
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    if (URLContexts.count == 0) {
        return;
    }
        
    NSURL *url = [URLContexts anyObject].URL;
    [FBSDKApplicationDelegate.sharedInstance application:UIApplication.sharedApplication
                                                 openURL:url
                                       sourceApplication:nil
                                              annotation:UIApplicationLaunchOptionsAnnotationKey];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
