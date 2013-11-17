//
//  AlbumViewController.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAlbumViewController.h"

#define DARK_GRAY  [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0]

@interface AlbumViewController : UITableViewController <AddAlbumViewControllerDelegate>

//Dictionary that contains an array of all album's information
@property (strong, nonatomic) NSMutableDictionary *albumDict;

//An array that contains all the names of every album.
@property (strong, nonatomic) NSMutableArray *listOfAlbumNames;

//The selected album to pass to the segue.
@property (strong, nonatomic) NSMutableArray *selectedAlbumInfo;

//reference to the list of albums, so we can reload it when a user
//adds a new album.
@property (strong, nonatomic) IBOutlet UITableView *albumTableView;

//When clicked goes to addAlbum View controller.
- (void)addAlbum:(id)sender;

@end
