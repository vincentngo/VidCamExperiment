//
//  AlbumCell.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/15/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
