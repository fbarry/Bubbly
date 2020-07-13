//
//  CameraView.h
//  Instagram
//
//  Created by Fiona Barry on 7/9/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    PHOTOS,
    CAMERA,
} SelectionType;

@protocol CameraViewDelegate <NSObject>

- (void)setImage:(UIImage *)image;

@end

@interface CameraView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) id<CameraViewDelegate>delegate;
@property (strong, nonatomic) UIViewController *viewController;

- (void)alertConfirmation;


@end

NS_ASSUME_NONNULL_END
