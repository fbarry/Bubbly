//
//  Utilities.m
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "Utilities.h"
#import <PopupDialog-Swift.h>

@implementation Utilities

+ (void) presentOkAlertControllerInViewController:(UIViewController *)viewController
                                      withTitle:(NSString *)title
                                        message:(NSString * _Nullable)message {
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle:title
                                                    message:message
                                                      image:nil
                                            buttonAlignment:UILayoutConstraintAxisHorizontal
                                            transitionStyle:PopupDialogTransitionStyleFadeIn
                                             preferredWidth:200
                                        tapGestureDismissal:YES
                                        panGestureDismissal:YES
                                              hideStatusBar:YES
                                                 completion:nil];
    PopupDialogButton *ok = [[PopupDialogButton alloc] initWithTitle:@"Ok" height:50 dismissOnTap:YES action:nil];
    [popup addButton:ok];
    [viewController presentViewController:popup animated:YES completion:nil];
}

+ (void)presentConfirmationInViewController:(UIViewController *)viewController
                                  withTitle:(nonnull NSString *)title
                                    message:(NSString * _Nullable)message
                                 yesHandler:(void(^)(void))yesHandler
                                  noHandler:(void(^ _Nullable)(void))noHandler {
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle:title
                                                    message:message
                                                      image:nil
                                            buttonAlignment:UILayoutConstraintAxisHorizontal
                                            transitionStyle:PopupDialogTransitionStyleFadeIn
                                             preferredWidth:200
                                        tapGestureDismissal:YES
                                        panGestureDismissal:YES
                                              hideStatusBar:YES
                                                 completion:nil];
    PopupDialogButton *yes = [[PopupDialogButton alloc] initWithTitle:@"Yes" height:50 dismissOnTap:YES action:yesHandler];
    PopupDialogButton *no = [[PopupDialogButton alloc] initWithTitle:@"No" height:50 dismissOnTap:YES action:noHandler];
    [popup addButton:yes];
    [popup addButton:no];
    [viewController presentViewController:popup animated:YES completion:nil];
}

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return newImage;
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (void)roundImage:(UIImageView *)imageView {
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.height, imageView.frame.size.height);
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.masksToBounds = NO;
    imageView.layer.borderWidth = 1.0f;
    imageView.clipsToBounds = YES;
}

@end
