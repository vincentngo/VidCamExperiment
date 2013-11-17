//
//  AppDelegate.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/14/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//Contains every album's name (key), where the file is located, the date created.
@property (strong, nonatomic) NSMutableDictionary *albumDict;


@end
