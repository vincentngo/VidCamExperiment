//
//  AddAlbumViewController.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAlbumViewControllerDelegate;

@interface AddAlbumViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *albumTitle;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mediaType;

//Passing the list of Albums already created by the user. We need reference to the list of albums to check if the album was created before so we don't overwrite it!
@property (strong, nonatomic) NSMutableArray *listOfAlbums;

@property (nonatomic, assign) id <AddAlbumViewControllerDelegate> delegate;

// The keyboardDone: method is invoked when the user taps Done on the keyboard
- (IBAction)keyboardDone:(id)sender;

// The create: method is invoked when the user taps the create button.
- (IBAction)create:(id)sender;

@end

/*
 The Protocol must be specified after the Interface specification is ended.
 Guidelines:
 - Create a protocol name as ClassNameDelegate as we did above.
 - Create a protocol method name starting with the name of the class defining the protocol.
 - Make the first method parameter to be the object reference of the caller as we did below.
 */
@protocol AddAlbumViewControllerDelegate

-(void)addAlbumViewController:(AddAlbumViewController *)controller didFinishWithSave:(BOOL)save;

@end
