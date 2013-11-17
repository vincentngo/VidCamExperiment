//
//  Video.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/29/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

// The name of the video
@property (nonatomic, strong) NSString *videoName;

//Where the video is stored in the documents directory.
@property (nonatomic, strong) NSString *videoPath;

//Initialize the properties above.
-(id) initWithName: (NSString *)videoName initWithPath: (NSString *)thePath;

@end
