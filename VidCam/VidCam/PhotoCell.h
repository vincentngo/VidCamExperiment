//
//  PhotoCell.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

//where the image is stored in the documents directoy
@property (nonatomic, strong) NSString *imageFilePath;

//the imageview object
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end
