//
//  VideoViewController.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/20/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface VideoViewController ()

@end

@implementation VideoViewController


- (void)viewDidLoad
{
    
    //Sets the album's name.
    self.albumName = [self.albumInformation objectAtIndex:1];
    
    self.title = self.albumName;
    
    //Grabs the document's directory's path, so we can just use it whenever we need to, instead of constantly retrieving it.
    self.documentsDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", self.albumName];
    
    NSLog(@"documents directory path is %@", self.documentsDirectoryPath);
    
    //Grabs all the files(photos) from the album folder.
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectoryPath error:NULL];
    
    //convert NSArray to NSMutableArray, so we can add photos into the list, and reset CollectionView when we need to.
    self.listOfVideos = [NSMutableArray arrayWithArray:directoryContent];
    
    //List of web view references
    self.listOfWebViewReferenes = [[NSMutableArray alloc]init];
    self.selectedVideos = [[NSMutableArray alloc] init];
    
    [self addMainToolBarButtons];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - UICollectionView Data Source

/*
 
 numberOfItemsInSection
 
 This basically returns the number of cells displayed in a given section.
 */

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self.listOfVideos count];
}

/*
 
 the data source ask how many sections are in the collection view. (The Default value will be 1 if you don't implement this. )
 
 */
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


/*
 
 cellForItemAtIndexPath
 
 Similar to UITableView, this is where you return the cell for a given index path. Here is where you can call the dequeueReusableCellWithReuseIdentifier method.
 This method basically checks if there is already a cell that can be reused, by specifying the identifier. But this is different compared to UITableViewCell.
 Unlike UITableViewCell, UICollectionViewCell doesn't have a default cell style, so the layout of the cell has to be specified by the programmer.
 
 */
- (VideoCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    
    //Get's the video's name from array.
    NSString *videoName = [self.listOfVideos objectAtIndex:rowNumber];
    //Gets the video's path.
    NSString *videoPath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, videoName];
    
    //Creating a cell, reusing old cells previous used before.
    VideoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"videoCellType" forIndexPath:indexPath];
    
    //We are going to keep a reference of the image Path value, so if the user wants to delete it, he shall delete it!
    cell.videoFilePath = videoPath;
    
    //an html string format, so a video will be able to play in UIWebView.
    NSString *htmlString = [NSString stringWithFormat:@"<video controls width=\"60\" height=\"80\"> <source src=\"%@\" > </video>", videoName];
    
    //Turn transparency off, to change color of the uiwebview background, or else it will always bew white.
    [cell.videoWebView setOpaque:NO];
    
    //I will always keep the cell's uiwebview reference, as long as the user does not delete it.
    //If the user decides to delete a video, then we need to remove all objects in this array.
    //re-populate the array with existing webviews. The reset is called when a user calls did select itemat
    //indexpath and he does delete it.
    //This is so we can have all referenes to every webview, to disable the video play ability.
    //We don't want the video to play when the user is trying to select multiple videos.
    if (![self.listOfWebViewReferenes containsObject:cell.videoWebView]){
        [self.listOfWebViewReferenes addObject:cell.videoWebView];
    }
    
    //Initially when the user has not pressed the action button, we want the user to interact with
    // the video, by being able to play  it.
    cell.videoWebView.scrollView.scrollEnabled = NO;
    [self.videoCollectionView setMultipleTouchEnabled:NO];
    cell.videoWebView.userInteractionEnabled = YES;
    
    
    //Set the background color to black.
    cell.videoWebView.backgroundColor = [UIColor blackColor];
    
    NSLog(@"the html string is %@", htmlString);
    
    [cell.videoWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:videoPath]];
    
    return cell;
    
}


//didSelectItemAtIndexPath method is called everytime the user taps on a cell. When the user taps on the cell, we may want to perform some actions such as: going to another view, pop up an image, or display an alert.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger rowNumber = [indexPath row];
    
    //Get's the video's name from array.
    NSString *videoName = [self.listOfVideos objectAtIndex:rowNumber];
    //Gets the video's path.
    NSString *videoPath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, videoName];
    
    //Check if sharing mode is on.
    if (self.sharing){
        
        //Create a new video object, with a given video name and where it's stored.
        Video *newVideo = [[Video alloc]initWithName:videoName initWithPath:videoPath];
        
        //Check to see if the video is already in the selectedVideos array
        if (![self.selectedVideos containsObject:newVideo]){
            
            // if its not yet in the array, add it into the selected videos array
            [self.selectedVideos addObject:newVideo];
        }
        
        //Check the size of the selectedVideos array, if its not zero, we will enable the buttons for sharing the content, or deleting the content
        //else if there are no videos in the array, we disable the buttons.
        if([self.selectedVideos count] != 0){
            self.deleteButton.enabled = YES;
            self.shareButton.enabled = YES;
        }
    }
    
    NSLog(@"size of selectedVideo is %d", [self.selectedVideos count]);
    
}

//Everytime the user deselects a cell it calls this method.
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Check to see if sharing mode is on.
    if(self.sharing)
    {
        
        //Grabs the video's name
        NSString *videoName = [self.listOfVideos objectAtIndex:[indexPath row]];
        //grabs the video's path
        NSString *videoPath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, videoName];
        
        //Create a video object
        Video *newVideo = [[Video alloc]initWithName:videoName initWithPath:videoPath];
        
        //remove the video from the array, since the user deselected it.
        [self.selectedVideos removeObject:newVideo];
        
        //Check to see if number of selected photos is zero.
        //If yes we want to disable the delete and share button.
        if([self.selectedVideos count] == 0){
            self.deleteButton.enabled = NO;
            self.shareButton.enabled = NO;
        }
        
        NSLog(@"size of selectedPhoto %d",[self.selectedVideos count]);
    }
}

//=============================================================================================
// imagePicker, this will get called when the user is done filming a video and want to save it
// We are naming every video by the date/time it was created, so this will keep it unique.
//=============================================================================================

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //Gets the album's name
    NSString *albumName = [self.albumInformation objectAtIndex:1];
    
    //Gets the date created in string format.
    NSString *date = [self currentDateandTime];
    
    //gets the documents directory path, and appends the album's name (this goes into the folder), and then the unique video's name.
    NSString  *videoPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@_video.mov", albumName, date]];
    
    //grabs the video's url
    NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    
    ///private/var/mobile/Applications/24A71F38-6F4D-4746-B00E-26DE4B537DE2/tmp/capture-T0x1f50e2f0.tmp.nWaVTK/capturedvideo.MOV
    //When the user stops recording, the video gets saved in a temporary folder.
    
    //converts the video URL to NSData, grabbing the video.
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    
    //Writes the video Data into the video album's folder.
    [videoData writeToFile:videoPath atomically:YES];
    
    //Grabs all the files(videos) from the album folder.
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectoryPath error:NULL];
    
    // reset the list of videos
    self.listOfVideos = [NSMutableArray arrayWithArray:directoryContent];
    
    // reload the video colleciton view.
    [self.videoCollectionView reloadData];
    
    //dismiss the image picker.
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UI Tool bar hidding and showing

//=================================================================
// Add Tool Bar Buttons, will add the tool bar buttons in
// every view.
//=================================================================

-(void)addMainToolBarButtons{
    
    self.sharing = NO;
    
    //Create three different Toolbar item buttons.
    
    //Camera button
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(activateVideoCamera:)];
    
    //Share button
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(activateShareToolbar:)];
    
    //Space between the share and camera button.
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //Store the buttons in an array.
    NSArray *buttons = [NSArray arrayWithObjects: camera, flexible, share, nil];
    
    //Set the tool bar with these buttons.
    [self.toolBar setItems: buttons animated:NO];
    
}

//=================================================================
// This removes the main tool bar and replaces it with the share,
// and cancel button
//=================================================================

-(void)addShareToolBarButtons{
    
    //Navigation bar cancel placed on the top right, so that the user can have an option to cancel sharing/deleting to go back to viewing photos.
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(activateMainToolbar:)];
    
    [self.navigationItem setRightBarButtonItem:barButton];
    
    //Adding a share and a delete button.
    self.shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(share:)];
    self.shareButton.width = 100;
    self.deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteVideos:)];
    self.deleteButton.width = 100;
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects: self.shareButton, flexible, self.deleteButton, nil];
    
    //Change the toolbar items with a share and a delete button.
    [self.toolBar setItems: buttons animated:NO];
    
    self.deleteButton.enabled = NO;
    self.shareButton.enabled = NO;
    
}


#pragma mark - Camera method and image picker delegate methods

//========================================================================
// Activates the iPhone's camera app, in video mode.
//========================================================================

- (void)activateVideoCamera:(id)sender {
    
    //create an ImagePickerController object
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //Make the source type of type camera
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //Enable kUTTYpeMovie, meaning only for recording videos
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,  nil];
    
    //Set the delegate
    picker.delegate = self;
    
    //Show camera app
    [self presentViewController:picker animated:YES completion:nil];
    
}

//========================================================================
// Activates the share tool bar items. Replaces the main tool bar items.
//========================================================================
-(void) activateShareToolbar:(id)sender{
    // activating the share tool bar, when the action icon button is clicked.
    
    //If sharing is set to NO
    if(!self.sharing){
        //Set sharing to yes
        self.sharing = YES;
        
        //Allow the collection view to have multiple selections
        [self.videoCollectionView setAllowsMultipleSelection:YES];
        
        //Set all the webviews in every cell's user interaction to no. The user is about to select multiple cells.
        //We disable play video feature.
        if (self.listOfWebViewReferenes != nil){
            for (UIWebView *webView in self.listOfWebViewReferenes){
                webView.userInteractionEnabled = NO;
            }
        }
        
    }
    
    //Show all the share tool bar items.
    [self addShareToolBarButtons];
}


//========================================================================
// Activates the main tool bar, replaces the share tool bar if exisited.
//========================================================================

-(void) activateMainToolbar:(id)sender{
    
    self.sharing = NO;
    [self.videoCollectionView setAllowsMultipleSelection:NO];
    
    //Deselect all cells.
    for(NSIndexPath *indexPath in self.videoCollectionView.indexPathsForSelectedItems){
        [self.videoCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    //Set the user interaction back, so they can play their videos.
    if (self.listOfWebViewReferenes != nil){
        for (UIWebView *webView in self.listOfWebViewReferenes){
            webView.userInteractionEnabled = YES;
        }
    }
    
    [self.selectedVideos removeAllObjects];
    
    NSLog(@"select videos size is %d", [self.selectedVideos count]);
    
    self.navigationItem.rightBarButtonItem = nil;
    [self addMainToolBarButtons];
}

//=========================================================================
// DELETE : Deletes all the selected photos.
//=========================================================================
-(void) deleteVideos:(id)sender{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    for (Video *aVideo in self.selectedVideos){
        
        NSString *videoPath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, aVideo.videoName];
        
        if([fileManager removeItemAtPath:videoPath error:nil] == YES){
            NSLog(@"sucessfully removed folder");
            
        }else{
            NSLog(@"removing the folder failed.");
        }
        
    }
    
    [self addMainToolBarButtons];
    
    //Reset the list of photos contained in the current album directory.
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectoryPath error:NULL];
    
    self.listOfVideos = [NSMutableArray arrayWithArray:directoryContent];
    
    //reload contents of the photocollection view.
    [self.videoCollectionView reloadData];
    
}
//=========================================================================
// Share, activates the action sheet, to show the menu options.
//=========================================================================

- (void) share:(id)sender {
    //This action method handles the share button of the Social Web View Controller.
    
    //Creating a new actionSheet object, with the following buttons (Facebook, Twitter, Email, SMS
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Sharing Menu"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Email", nil];
    
    //Makes the background of the action sheet a bit transparent.
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
}

//===============================================================================================
// Action sheet, showing the different sharing options.
//===============================================================================================

//There are three UIActionDelegate methods.
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Email"]) {
        
        //open email
        [self openEmail];
        
    }
    
    //ATTENTION:
    //Cannot send photos through SMS, i don't think there is an API for it like Email, Twitter or Facebook.
}//

//===============================================================================================


//==============================================================================
// SENDING PHOTOS USING MAIL: Multiple Images selector can be sent through mail.
//==============================================================================

-(void) openEmail{
    
    //Check the device you are using, is it able to send an email?
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        //Set the delegate, so it can respond to the delegate's methods.
        mail.mailComposeDelegate = self;
        
        for (Video *aVideo in self.selectedVideos){
            
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, aVideo.videoName];
            NSData *aData = [NSData dataWithContentsOfFile:imagePath];
            [mail addAttachmentData:aData mimeType:@"video/mov" fileName:aVideo.videoName];
            
        }
        
        [self presentViewController:mail animated:YES completion:nil];
        
        //Not able to send email on device, display an alert.
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Your device doesn't support emailing"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - MF Mail Compose View Controller Delegate Method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
            //With every result message, you can perform some action to respond to the user.
            //Just added print statements to show you which one has been called.
        case MFMailComposeResultCancelled:
            //NSLog(@"You pressed the cancel button, go back to app");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail has been saved to the draft folder of your mail app");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail has been sent.");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail has failed to send, error");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

//============================================================================
//============================================================================


//=========================================================================
// Returns the current date in a form of a string. This is used to name
// different photos when saved to a folder. This offers unique name
// for any photo saved.
//=========================================================================

- (NSString *)currentDateandTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMddyyyy_HHmmssSS"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    return dateString;
}



//=========================================================================

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
