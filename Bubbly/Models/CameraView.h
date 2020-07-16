//
//  CameraView.h
//  Bubbly
//
//  Created by Fiona Barry on 7/15/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    PHOTOS,
    CAMERA,
} SelectionType;

@protocol CameraViewDelegate <NSObject>

- (void)setImage:(UIImage *)image withName:(NSString *)name;

@end

@interface CameraView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) id<CameraViewDelegate>delegate;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSString *name;

- (void)alertConfirmation;

@end

NS_ASSUME_NONNULL_END
