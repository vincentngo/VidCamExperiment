//
//  AppDelegate.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/14/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeAppearance];
    
    /************************************
     All application-specific and user data files must be written to the Documents directory. Nothing can be written
     into application's main bundle because it is locked for writing after your app is published. The contents of the
     Documents directory are backed up by iTunes during backup of an iOS device. Therefore, the user can recover the
     data written by your app from an earlier device backup.
     
     The Documents directory path on an iOS device is different from the one used for iOS Simulator.
     
     To obtain the Documents directory path, you use the NSSearchPathForDirectoriesInDomains function.
     However, this function was designed originally for Mac OS X, where multiple such directories could exist.
     Therefore, it returns an array of paths rather than a single path.
     For iOS, the resulting array's objectAtIndex:0 is the path to the Documents directory.
     ************************************/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"listOfAlbums.plist"];
    
    NSMutableDictionary *albumDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    if (!albumDict){
        /*
         In this case, the listOfAlbums.plist file does not exist in the documents directory.
         This will happen when the user launches the app for the very first time.
         Therefore, read the plist file from the main bundle to show the user some example of albums.
         
         Means, I have to create two folders, one for a sample photo and one for a sample video.
         */
        NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"listOfAlbums" ofType:@"plist"];
        
        albumDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
//        albumDict = [self AddSampleAlbum];
    }
    
    self.albumDict = albumDict;
    
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                             error:&setCategoryError];
    if (!ok) {
        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
    }
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"listOfAlbums.plist"];
    
    
    [self.albumDict writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    
}

//Creates two folders and adds them to the plist, as samples.
//This method returns a dictionary of albums.
-(NSMutableDictionary *)AddSampleAlbum{
    
    //find the list of paths in the directorys domain
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0]; // Get documents folder
    
    //Initially when the user first downloads the app, we will create two sample albums for them. One photo album and one video album.
    //we are appending the album's names to the documents directory path to create a folder.
    NSString *PhotoSamplePath = [documentsDirectoryPath stringByAppendingPathComponent:@"/Blacksburg Photos"];
    NSString *VideoSamplePath = [documentsDirectoryPath stringByAppendingPathComponent:@"/Blacksburg Videos"];
    
    //create a date object to grabs when the album was created.
    NSDate *date = [NSDate date];
    
    //Note that all these arrays will be stored in the albumDict. We will be keeping track of information related to every album in a plist, whenever the app runs again.
    
    //Create a photoAlbumInfo array to store all the information about an album.
    NSMutableArray *photoAlbumInfo = [[NSMutableArray alloc]init];
    
    //Add the type of the album, in this case phtoo
    [photoAlbumInfo addObject:@"photo"];
    
    //add the album's name
    [photoAlbumInfo addObject:@"Blacksburg Photos"];
    
    //add the album's date created
    [photoAlbumInfo addObject:date];
    
    //Create a videoAlbumInfo array to store all the information about an album.
    NSMutableArray *videoAlbumInfo = [[NSMutableArray alloc]init];
    
    //add the type of the album, in this case video
    [videoAlbumInfo addObject:@"video"];
    
    //add the album's name
    [videoAlbumInfo addObject:@"Blacksburg Videos"];
    
    //add the album's date created
    [videoAlbumInfo addObject:date];
    
    NSMutableDictionary *sampleAlbumsDict = [[NSMutableDictionary alloc]init];
    
    //Save the albums in the dictionary.
    [sampleAlbumsDict setObject:videoAlbumInfo forKey:@"Blacksburg Videos"];
    [sampleAlbumsDict setObject:photoAlbumInfo forKey:@"Blacksburg Photos"];
    
    //Create the albums folder in the documents directory.
    [self CreateAlbumFolderWithPath:PhotoSamplePath];
    [self CreateAlbumFolderWithPath:VideoSamplePath];
    
    return sampleAlbumsDict;
}

// creates a folder in the documents directory, given a path.

-(BOOL)CreateAlbumFolderWithPath: (NSString *)folderPath{
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        
        NSError* error;
        
        if ([[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]){
            //Sucess
            return YES;
        }else{
            return NO;
        }
        
    }else{
        //Failure
        
        NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
        NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        
        return NO;
    }
    
}


-(void)customizeAppearance {
    /******************************
     NavigationBar customization
     *****************************/
    
    //create navigation bar back ground image
    UIImage *navBarImage = [UIImage imageNamed:@"navbars.png"];
    UIImage *navBarLandscapeImage = [UIImage imageNamed:@"navbarslandscape.png"];
    
    //set the navigation bar background image
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:navBarLandscapeImage forBarMetrics:UIBarMetricsLandscapePhone];
    
    //create a button image for generic use that can be resizable
    UIImage *barButton = [[UIImage imageNamed:@"bar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    //set the button background image
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //create a back button image
    UIImage *backButton = [[UIImage imageNamed:@"back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 6)];
    
    //set the back button background image
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    /*
     
     For detailed information about how to "USER INTERFACE CUSTOMIZATION" in iOS please check the links at below
     
     http://developer.apple.com/library/ios/#documentation/uikit/reference/UIAppearance_Protocol/Reference/Reference.html
     
     http://mobileorchard.com/how-to-make-your-app-stand-out-with-the-new-ios-5-appearance-api/
     
     http://www.raywenderlich.com/4344/user-interface-customization-in-ios-5
     
     http://mobiledevelopertips.com/user-interface/ios-5-customize-uinavigationbar-and-uibarbuttonitem-with-appearance-api.html
     
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
