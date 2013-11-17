//
//  VideoViewController.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/20/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "VideoCell.h"
#import "Video.h"
#import <MessageUI/MessageUI.h>

@interface VideoViewController : UIViewController <UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

//albumInformation contains information regarding the album. Such as the type of album (video/photo), and the album's name in the documents directory.
@property (nonatomic, strong) NSMutableArray *albumInformation;

//The list of videos in the album.
@property (nonatomic, strong) NSMutableArray *listOfVideos;

//Stores a reference to the document's directory path, so we can save photos into the right folder.
@property (nonatomic, strong) NSString *documentsDirectoryPath;

//Name of the album
@property (nonatomic, strong) NSString *albumName;

//Reference to the collection view, so whenever a new video is created we reload the collection view.
@property (strong, nonatomic) IBOutlet UICollectionView *videoCollectionView;

@property (nonatomic, strong) NSMutableArray *selectedVideos;

//==========================================================
//                  Tool bar properities
//==========================================================

@property(nonatomic) BOOL sharing;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIBarButtonItem *deleteButton;

//============================================================================
// Properities for saving all UIWebView References in every cell.
// This is because, we want to have a way to disable webview interaction when
// user wants to share a video, so we need to disable the play button.
//============================================================================

@property (nonatomic) BOOL isSavedWebView;
@property (nonatomic, strong) NSMutableArray *listOfWebViewReferenes;

//===================================
//     Stuff for experimenting
//===================================

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

//
//MPMoviePlayerController *movie = [[MPMoviePlayerController alloc] initWithContentURL:fileUrl];
//movie.shouldAutoplay = NO;
//UIImage *image = [movie thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//[movie release];

@end
