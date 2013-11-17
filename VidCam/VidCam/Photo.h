//
//  Photo.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/29/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

//stores the photo's name.
@property (nonatomic, strong) NSString *photoName;

//stores the UIImage obtained from the album's document directory.
@property (nonatomic, strong) UIImage *image;

//Initialize the properties above.
-(id) initWithName: (NSString *)photoName initWithImage: (UIImage *)theImage;

@end
