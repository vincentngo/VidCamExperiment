//
//  AddAlbumViewController.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "AddAlbumViewController.h"

@interface AddAlbumViewController ()

@end

@implementation AddAlbumViewController

- (void)viewDidLoad
{
    // Set the default media type to be video.
    self.mediaType.selectedSegmentIndex = 0;
    
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)keyboardDone:(id)sender {
    
    [sender resignFirstResponder];
    
}

- (IBAction)create:(id)sender {
    
    NSString *albumTitle = self.albumTitle.text;
    
    BOOL isContainedInAlbum = [self containsAlbum:albumTitle];
    
    if(albumTitle.length != 0 && !isContainedInAlbum){
        
        [self.delegate addAlbumViewController:self didFinishWithSave:YES];
        
    }else{
        
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Album Title Invalid"
                                                               message:@"Please name your album,"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
        
        [alertMessage show];
    }
}


-(BOOL) containsAlbum:(NSString *)string{
    
    for (NSString *str in self.listOfAlbums){
        if([str isEqualToString:string]){
            return YES;
        }
    }
    return NO;
    
}

@end
