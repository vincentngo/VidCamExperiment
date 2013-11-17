//
//  Photo.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/29/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "Photo.h"

@implementation Photo

//========================================================================================
// When a new photo is created, we can initialize the photo name and UI Image.
//========================================================================================

-(id) initWithName:(NSString *)photoName initWithImage:(UIImage *)theImage{
    
    if (self = [super init]){
        self.photoName = photoName;
        self.image = theImage;
    }
    return self;
}

//========================================================================================
// Override the isEqual method, so we can compare two Photo objects, instead of NSObject
//========================================================================================
-(BOOL)isEqual:(id)object{
    // check if the object is this
    if(object == self){
        return YES;
    }
    
    //check if the object is a photo class, else return no
    if(!object || ![object isKindOfClass:[self class]]){
        return NO;
    }
    
    //If it is a photo object, we check to see if the photo name are equal, since all photos are unique in a documents directory.
    if([self.photoName isEqualToString:((Photo *)object).photoName] || self.image == ((Photo *)object).image){
        return YES;
    }else{
        return NO;
    }
}

@end
