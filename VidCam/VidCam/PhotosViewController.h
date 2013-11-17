//
//  PhotosViewController.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "PhotoCell.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface PhotosViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate>


//albumInformation contains information regarding the album. Such as the type of album (video/photo), and the album's name in the documents directory.
@property (nonatomic, strong) NSMutableArray *albumInformation;

//The list of photos in the album.
@property (nonatomic, strong) NSMutableArray *listOfPhotos;

//The name of the album
@property (nonatomic, strong) NSString *albumName;

//Stores a reference to the document's directory path, so we can save photos into the right folder.
@property (nonatomic, strong) NSString *documentsDirectoryPath;

//Keeps a reference to the collection view, so we can update the uicollection view cells when new photos are taken, that need to be updated.
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;

//A way to store all the selected photos
@property (strong, nonatomic) NSMutableArray *selectedPhotos;


@property(nonatomic) BOOL sharing;

//==========================================
// Modal View Selected Image
//==========================================
@property (strong, nonatomic) UIImage *selectedImageToView;

//==========================================
// Tool bar item references.
//==========================================

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIBarButtonItem *deleteButton;
@end
