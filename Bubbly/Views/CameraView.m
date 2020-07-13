//
//  CameraView.m
//  Instagram
//
//  Created by Fiona Barry on 7/9/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "CameraView.h"
#import "Utilities.h"

@implementation CameraView

UIImagePickerController *imagePickerVC;

- (void)alertConfirmation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pick Image Source" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take New Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setPicture:CAMERA];
    }];
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"Choose Existing Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setPicture:PHOTOS];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:camera];
    [alert addAction:photos];
    [alert addAction:cancel];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)setPicture:(SelectionType) type {
    imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
        
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || type == PHOTOS) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self.viewController presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [Utilities resizeImage:info[UIImagePickerControllerOriginalImage] withSize:CGSizeMake(1000, 1000)];
    [self.delegate setImage:image];
    [imagePickerVC dismissViewControllerAnimated:YES completion:nil];
}


@end
