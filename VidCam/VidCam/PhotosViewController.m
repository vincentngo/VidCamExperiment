//
//  PhotosViewController.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "PhotosViewController.h"
#import "Photo.h"
#import "ShowPhotoViewController.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController

- (void)viewDidLoad
{
    if (self.albumInformation != nil)
    {
        self.albumName = [self.albumInformation objectAtIndex:1];
    }
    self.title = self.albumName;
    self.documentsDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", self.albumName];
    
    NSLog(@"documents directory path is %@", self.documentsDirectoryPath);
    
    //Grabs all the files(photos) from the album folder.
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectoryPath error:NULL];
    
    //convert NSArray to NSMutableArray, so we can add photos into the list, and reset CollectionView when we need to.
    self.listOfPhotos = [NSMutableArray arrayWithArray:directoryContent];
    
    [self addMainToolBarButtons];
    NSLog(@"size of list of photos is %d", [self.listOfPhotos count]);
    
    self.selectedPhotos = [[NSMutableArray alloc]init];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



//============================================================================
// When the share button is clicked, it will activate the UIActionSheet.
// To select which social media, email you want to use to share.
//============================================================================
#pragma mark - UIActionSheet Delegate Method and helper methods.

- (void) share:(id)sender {
    //This action method handles the share button of the Social Web View Controller.
    
    //Creating a new actionSheet object, with the following buttons (Facebook, Twitter, Email, SMS
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Sharing Menu"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Facebook", @"Twitter", @"Email", nil];
    
    //Makes the background of the action sheet a bit transparent.
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
}



//There are three UIActionDelegate methods.
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //Perform one of these methods based on the button pressed.
    if  ([buttonTitle isEqualToString:@"Facebook"]) {
        
        //open facebook sheet
        [self showFacebookPostSheet];
        
    }
    if ([buttonTitle isEqualToString:@"Twitter"]) {
        
        //open twitter sheet
        [self showTwitterPostSheet];
        
    }
    if ([buttonTitle isEqualToString:@"Email"]) {
        
        //open email
        [self openEmail];
        
    }
    
    
    //ATTENTION:
    //Cannot send photos through SMS, i don't think there is an API for it like Email, Twitter or Facebook.
}

//=================================================================
// FACEBOOK - Posting Sheet to share photos
//=================================================================
-(void) showFacebookPostSheet{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        //Insert an initial text for the user.
        [facebookPost setInitialText:@"Insert Post here:"];
        
        //for each loop looping through the array of selected photos to send.
        for (Photo *aPhoto in self.selectedPhotos){
            [facebookPost addImage:aPhoto.image];
            NSLog(@"image is %@", aPhoto.photoName);
        }
        
        [self presentViewController:facebookPost animated:YES completion:nil];
        
    }else{
        //If your facebook account is not set up, its goign to show an alert.
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}



//=================================================================
// Tweeter - Posting Sheet , warning: Twitter only allows 1 photo
// per tweet.
//=================================================================
- (void) showTwitterPostSheet{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] && [self.selectedPhotos count] < 2)
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //Inserting an initial text for the user. (Really cool because you can create automated messages for users)
        [tweetSheet setInitialText:@"Insert Tweet Message Here"];
        
        for (Photo *aPhoto in self.selectedPhotos){
            [tweetSheet addImage:aPhoto.image];
            NSLog(@"image is %@", aPhoto.photoName);
        }
        
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        //If your twitter account is not set up, its going to show an alert.
        
        //Twitter only allows one photo per tweet, so we are going to put a restriction, by
        //telling the user you can't select more than 2.
        if ([self.selectedPhotos count] != 1 && [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"Warning, Twitter only allows 1 photo per tweet. Please select only one."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    
}
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
        
        for (Photo *aPhoto in self.selectedPhotos){
            
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, aPhoto.photoName];
            NSData *aData = [NSData dataWithContentsOfFile:imagePath];
            [mail addAttachmentData:aData mimeType:@"image/png" fileName:aPhoto.photoName];
            
            
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


#pragma mark - UI Tool bar hidding and showing

//=================================================================
// Add Tool Bar Buttons, will add the tool bar buttons in
// every view.
//=================================================================

-(void)addMainToolBarButtons{
    
    self.sharing = NO;
    
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(activateCamera:)];
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(activateShareToolbar:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    NSArray *buttons = [NSArray arrayWithObjects: camera, flexible, share, nil];
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
    self.deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deletePhotos:)];
    self.deleteButton.width = 100;
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects: self.shareButton, flexible, self.deleteButton, nil];
    [self.toolBar setItems: buttons animated:NO];
    
    self.deleteButton.enabled = NO;
    self.shareButton.enabled = NO;
    
}

//========================================================================
// Activates the share tool bar items. Replaces the main tool bar items.
//========================================================================

-(void) activateShareToolbar:(id)sender{
    
    // check to see if sharing is ON
    if(!self.sharing){
        
        //turn sharing ON
        self.sharing = YES;
        //Allow the collection view to have multiple cell selections
        [self.photoCollectionView setAllowsMultipleSelection:YES];
        
    }
    
    //Show the share tool bar items
    [self addShareToolBarButtons];
}

//========================================================================
// Activates the main tool bar, replaces the share tool bar if exisited.
//========================================================================

-(void) activateMainToolbar:(id)sender{
    
    //When activating the main tool bar, sharing mode is turned off
    self.sharing = NO;
    //Don't allow mutiple cell selection
    [self.photoCollectionView setAllowsMultipleSelection:NO];
    
    //Deselect every cell selected.
    for(NSIndexPath *indexPath in self.photoCollectionView.indexPathsForSelectedItems){
        [self.photoCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    //Remove all the objects added to the selected photos
    [self.selectedPhotos removeAllObjects];
    
    //Set the
    self.navigationItem.rightBarButtonItem = nil;
    [self addMainToolBarButtons];
}


//=========================================================================
// DELETE : Deletes all the selected photos.
//=========================================================================
-(void) deletePhotos:(id)sender{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    for (Photo *aPhoto in self.selectedPhotos){
        
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, aPhoto.photoName];
        
        if([fileManager removeItemAtPath:imagePath error:nil] == YES){
            NSLog(@"sucessfully removed folder");
            
        }else{
            NSLog(@"removing the folder failed.");
        }
        
    }
    
    [self addMainToolBarButtons];
    
    //Reset the list of photos contained in the current album directory.
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectoryPath error:NULL];
    
    self.listOfPhotos = [NSMutableArray arrayWithArray:directoryContent];
    
    //reload contents of the photocollection view.
    [self.photoCollectionView reloadData];
    
}



#pragma mark - Camera method and image picker delegate methods

//=========================================================================
// This method when called, activates the camera (picture mode).
//=========================================================================

- (void) activateCamera:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //Tells us what library to open, in this case we open the iPhone
    //camera app.
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //media types, you can include video and pictures if you wanted to.
    //For now we will set KUTTYpe image for photo album.
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
    
    //Sets the delegate for the imagepickercontroller
    picker.delegate = self;
    
    //Animinating present view controller.
    [self presentViewController:picker animated:YES completion:nil];
}


//=========================================================================
// When the user taps the "use" button, after taking the photo, this
// delegate method gets called. We use this method to write the image to
// the user's folder photo album.
//=========================================================================

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    NSString *albumName = [self.albumInformation objectAtIndex:1];
    NSLog(@"album name is %@", albumName);
    NSString *date = [self currentDateandTime];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@_image.jpg", albumName, date]];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:imagePath atomically:YES];
    
    //Reload COllectionView
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectoryPath error:NULL];
    
    //convert NSArray to NSMutableArray, so we can add photos into the list, and reset CollectionView when we need to.
    self.listOfPhotos = [NSMutableArray arrayWithArray:directoryContent];
    
    [self.photoCollectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


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






#pragma mark - UICollectionView Data Source

/*
 
 numberOfItemsInSection
 
 This basically returns the number of cells displayed in a given section.
 */

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self.listOfPhotos count];
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
- (PhotoCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    
    NSString *imageName = [self.listOfPhotos objectAtIndex:rowNumber];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, imageName];
    NSLog(@"the image path is %@", imagePath);
    
    PhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"photoVideoTypeCell" forIndexPath:indexPath];
    
    //We are going to keep a reference of the image Path value, so if the user wants to delete it, he shall delete it!
    cell.imageFilePath = imagePath;
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *originalImage = [UIImage imageWithContentsOfFile:imagePath];
        UIImage *thumbNail = [self shrinkImage:originalImage withSize:CGSizeMake(200, 200)];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image =  thumbNail;
        });
        
    });
    
    return cell;
    
}




#pragma mark - UICollectionViewDelegate

//didSelectItemAtIndexPath method is called everytime the user taps on a cell. When the user taps on the cell, we may want to perform some actions such as: going to another view, pop up an image, or display an alert.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *imageName = [self.listOfPhotos objectAtIndex:[indexPath row]];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, imageName];
    
    UIImage *originalImage = [UIImage imageWithContentsOfFile:imagePath];
    
    //selecting an image to view if sharing is OFF
    if(!self.sharing)
    {
        self.selectedImageToView = originalImage;
        [self.photoCollectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"ShowPhoto" sender:self];
    }else{
        
        
        
        //Create a new photo object, with the imageName, and the original UIImage.
        Photo *newPhoto = [[Photo alloc]initWithName:imageName initWithImage:originalImage];
        
        //Checks to see if the photo selected is already contained in the list of selected photos.
        if (![self.selectedPhotos containsObject:newPhoto]){
            [self.selectedPhotos addObject:newPhoto];
        }
        
        //Check to see if the number of photos selected is zero
        //we want to disable delete and share button if nothing is selected.
        if([self.selectedPhotos count] != 0){
            self.deleteButton.enabled = YES;
            self.shareButton.enabled = YES;
        }
        //testing
        NSLog(@"size of selectedPhoto %d",[self.selectedPhotos count]);
    }
    
    
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.sharing)
    {
        
        NSString *imageName = [self.listOfPhotos objectAtIndex:[indexPath row]];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath, imageName];
        
        UIImage *originalImage = [UIImage imageWithContentsOfFile:imagePath];
        
        Photo *newPhoto = [[Photo alloc]initWithName:imageName initWithImage:originalImage];
        
        [self.selectedPhotos removeObject:newPhoto];
        
        //Check to see if number of selected photos is zero.
        //If yes we want to disable the delete and share button.
        if([self.selectedPhotos count] == 0){
            self.deleteButton.enabled = NO;
            self.shareButton.enabled = NO;
        }
        
        
        NSLog(@"size of selectedPhoto %d",[self.selectedPhotos count]);
        
    }
}

#pragma mark - Segue

//=======================================================================
// Prepare for segue will be called, when the user clicked on a single
// photo to view. This will go to the modal view controller
//to display an enlarge original image of the thumbnail.
// keep in mind that, this will only be called when the sharing feature
// is currently disabled.
//=======================================================================

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        ShowPhotoViewController *showPhotoViewController = segue.destinationViewController;
        
        showPhotoViewController.selectedImage = self.selectedImageToView;
    }
}


//========================================================================
// Method to shrink the original image to be displayed in the collection.
//========================================================================

-(UIImage *)shrinkImage:(UIImage *)original withSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [original drawInRect:CGRectMake(0,0,size.width, size.height)];
    
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnail;
    
}

//==========================================================================


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
