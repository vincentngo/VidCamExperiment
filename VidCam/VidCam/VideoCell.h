//
//  VideoCell.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/20/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIWebView *videoWebView;

//<div align="center"><video src="videoCaptor.mp4" controls="controls"></video></div>
@property (strong, nonatomic) NSString *htmlTag;

@property (nonatomic, strong) NSString *videoFilePath;



@end
