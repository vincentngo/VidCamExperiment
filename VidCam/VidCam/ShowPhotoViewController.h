//
//  ShowPhotoViewController.h
//  VidCam
//
//  Created by iOS Developer on 5/9/13.
//  Copyright (c) 2013 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPhotoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage *selectedImage;

@end
