//
//  AlbumCell.h
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UITableViewCell

//The image in the table view to tell the user if its a video album or a photo album.
@property (strong, nonatomic) IBOutlet UIImageView *albumTypeImageView;

//The album title label.
@property (strong, nonatomic) IBOutlet UILabel *albumTitleLabel;

//The date created label.
@property (strong, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@end
