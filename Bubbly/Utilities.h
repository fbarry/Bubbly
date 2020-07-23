//
//  Utilities.h
//  Bubbly
//
//  Created by Fiona Barry on 7/13/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utilities : NSObject

+ (void) presentOkAlertControllerInViewController:(UIViewController *)viewController
                                        withTitle:(NSString *)title
                                          message:(NSString * _Nullable)message;
+ (void)presentConfirmationInViewController:(UIViewController *)viewController
                                  withTitle:(nonnull NSString *)title
                                 yesHandler:(void(^)(void))yesHandler;

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

+ (void)roundImage:(UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
