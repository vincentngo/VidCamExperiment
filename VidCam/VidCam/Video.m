//
//  Video.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/29/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "Video.h"

@implementation Video

//========================================================================================
// Override the isEqual method, so we can compare two Video objects, instead of NSObject
//========================================================================================
-(BOOL)isEqual:(id)object{
    if(object == self){
        return YES;
    }
    
    if(!object || ![object isKindOfClass:[self class]]){
        return NO;
    }
    
    if([self.videoName isEqualToString: ((Video *)object).videoName] || [self.videoPath isEqualToString:((Video *)object).videoPath]){
        return YES;
    }else{
        return NO;
    }
}

//===================================================================================================
// When a new video is created, we can initialize the video name and path where the video is located.
//===================================================================================================

-(id) initWithName:(NSString *)videoName initWithPath:(NSString *)thePath{
    
    if (self = [super init]){
        self.videoName = videoName;
        self.videoPath = thePath;
    }
    return self;
}

@end
