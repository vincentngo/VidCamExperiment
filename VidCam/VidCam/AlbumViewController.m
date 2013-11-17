//
//  AlbumViewController.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "AlbumViewController.h"
#import "AppDelegate.h"
#import "AlbumCell.h"
#import "PhotosViewController.h"
#import "VideoViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Obtain an object reference to the App Delegate object.
    self.albumDict = appDelegate.albumDict;
    
    // Set up the Edit system button on the left of the navigation bar
    self.listOfAlbumNames = (NSMutableArray *)[self.albumDict allKeys];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    /*
     editButtonItem is provided by the system with its own functionality. Tapping it triggers editing by
     displaying the red minus sign icon on all rows. Tapping the minus sign displays the Delete button.
     The Delete button is handled in the method tableView: commitEditingStyle: forRowAtIndexPath:
     */
    
    // Instantiate an Add button (with plus sign icon) to invoke the addCity: method when tapped.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addAlbum:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
    
    [super viewDidLoad];
}

#pragma mark - Add Album Method

// The addAlbum: method is invoked when the user taps the Add button created at run time.
-(void)addAlbum:(id)sender
{
    // Perform the segue named ShowAddAlbumView
    [self performSegueWithIdentifier:@"ShowAddAlbumView" sender:self];
}


/*
 This is the AddAlbumViewController's delegate method we created. AddAlbumViewController informs
 the delegate RootViewController that the user tapped the Save button if the parameter is YES.
 */
-(void)addAlbumViewController:(AddAlbumViewController *)controller didFinishWithSave:(BOOL)save{
    
    if(save){
        
        //Get the album title entered by the user on the AddAlbumViewController's UI
        NSString *albumTitleEntered = controller.albumTitle.text;
        
        int albumTypeSelected = controller.mediaType.selectedSegmentIndex;
        
        //Get the album type selected by the user. 0 = video 1 = photo
        NSString *albumType = (albumTypeSelected == 0) ? @"video" : @"photo";
        
        //Create an album information to store all the information retrieved
        NSMutableArray *albumInformation = [[NSMutableArray alloc]init];
        
        //Create a new date object, for the date this album was created
        NSDate *todayDate = [[NSDate alloc]init];
        
        //Add all the information inside the albumInformation data structure.
        [albumInformation addObject:albumType];
        [albumInformation addObject:albumTitleEntered];
        [albumInformation addObject:todayDate];
        
        //Add the albumInformation to the list of albums dictionary.
        [self.albumDict setObject:albumInformation forKey:albumTitleEntered];
        
        //update listOfAlbums
        self.listOfAlbumNames = (NSMutableArray *)[self.albumDict allKeys];
        
        //This creates the folder in the documents directory
        [self createNewFolderInDirectory:albumTitleEntered];
        
        //Reload the rows and sections of the Table View
        [self.albumTableView reloadData];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



#pragma mark - UITableViewDataSource Protocol Methods

//The number of sections in the tableView, in this case there isn't any but one
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Number of dates is the number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listOfAlbumNames count];
}

// Asks the data source to return a cell to insert in a particular table view location
- (AlbumCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    
    //Get the name of the album clicked
    NSString *nameOfAlbum = [self.listOfAlbumNames objectAtIndex:rowNumber];
    
    //Grabs the album's information in the form of an array. (Size of 3)
    NSMutableArray *albumInformation = [self.albumDict objectForKey:nameOfAlbum];
    
    //Get the type of the album, Video or Photo?
    NSString *typeOfAlbum = [albumInformation objectAtIndex:0];
    
    //Gets the date this album was created.
    NSDate *date = [albumInformation objectAtIndex:2];
    
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    
    [format setDateFormat:@"MMM dd, yyyy"];
    
    NSString *formattedDate = [format stringFromDate:date];
    
    AlbumCell *cell = (AlbumCell *)[tableView dequeueReusableCellWithIdentifier:@"albumCellType"];
    
    cell.albumTypeImageView.image = ([typeOfAlbum isEqualToString:@"video"]) ? [UIImage imageNamed:@"videoIcon.png"] : [UIImage imageNamed:@"cameraIcon.png"];
    
    cell.albumTitleLabel.text = nameOfAlbum;
    cell.dateCreatedLabel.text = formattedDate;
    
    [cell.albumTypeImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [cell.albumTitleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [cell.dateCreatedLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    
    [cell.accessoryView setBackgroundColor:[UIColor whiteColor]];
    
    //Sets the background color selected cell color.
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:DARK_GRAY];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

//Tapping an album, displays the list of photos or videos
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger rowNumber = [indexPath row];
    
    //Get the name of the album clicked
    NSString *nameOfAlbum = [self.listOfAlbumNames objectAtIndex:rowNumber];
    
    //Grabs the album's information in the form of an array. (Size of 3)
    NSMutableArray *albumInformation = [self.albumDict objectForKey:nameOfAlbum];
    
    //grab the type of album
    NSString *albumType = [albumInformation objectAtIndex: 0];
    
    self.selectedAlbumInfo = albumInformation;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([albumType isEqualToString:@"photo"]){
        
        [self performSegueWithIdentifier:@"ShowAlbumContent" sender:self];
        
    }else{
        
        [self performSegueWithIdentifier:@"ShowVideoAlbum" sender:self];
        
    }
    
    
}


// We allow each row (city) of the table view to be editable, i.e., deletable or movable
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// This is the method invoked when the user taps the Delete button in the Edit mode
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowNumber = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {  // Handle the Delete action
        
        NSString *albumToDelete = [self.listOfAlbumNames objectAtIndex:rowNumber];
        
        [self.albumDict removeObjectForKey:albumToDelete]; //Remove the album from the dictionary
        
        //remove the album's folder from the documents directory.
        [self removeFolderFromDirectory:albumToDelete];
        
        //Update the list of albums
        self.listOfAlbumNames = (NSMutableArray *)[self.albumDict allKeys];
        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.albumTableView reloadData];
    }
}

#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"ShowAddAlbumView"]) {
        
        // Obtain the object reference of the destination view controller
        AddAlbumViewController *addAlbumViewController = [segue destinationViewController];
        
        // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
        addAlbumViewController.delegate = self;
        addAlbumViewController.listOfAlbums = self.listOfAlbumNames;
    }else if ([segueIdentifier isEqualToString:@"ShowAlbumContent"]){
        
        PhotosViewController *photoViewController = [segue destinationViewController];
        
        photoViewController.albumInformation = self.selectedAlbumInfo;
        
    }else if ([segueIdentifier isEqualToString:@"ShowVideoAlbum"]){
        
        VideoViewController *videoViewController = [segue destinationViewController];
        
        videoViewController.albumInformation = self.selectedAlbumInfo;
        
    }
    
}




#pragma mark - Writing to Documents Directory

-(BOOL)createNewFolderInDirectory: (NSString *)albumName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0]; // Get documents folder
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *newAlbumDirectory = [documentsDirectoryPath stringByAppendingPathComponent:albumName];
    
    NSError *error = nil;
    
    //createDirectoryAtPath - is the path to the folder that has to be created
    //withIntermediateDirectories - by setting this to YES you can create multiple folders e.g. album/blacksburg will create the folder in the middle
    //if it does not exisit. Meaning it creates the album and the blacksburg folder.
    //attributes - allows you to modifiy the folder's information such as date modified, and editied etc.
    //always good to have an error object, instead of returning NO, you can also see what type of error it is.
    if([fileManager createDirectoryAtPath:newAlbumDirectory
              withIntermediateDirectories:YES attributes:nil error:&error]){
        NSLog(@"Successfully created the direcotry.");
        return YES;
    }else{
        NSLog(@"Failed to create the directory. Error = %@", error);
        
        return NO;
    }
}

//Removes an album selected...
-(BOOL)removeFolderFromDirectory: (NSString *)albumName{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *albumPath = [documentsDirectoryPath stringByAppendingPathComponent:albumName];
    
    if([fileManager removeItemAtPath:albumPath error:nil] == YES){
        NSLog(@"sucessfully removed folder");
        return YES;
    }else{
        NSLog(@"removing the folder failed.");
        return NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
