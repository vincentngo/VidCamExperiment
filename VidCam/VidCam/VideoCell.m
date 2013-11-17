//
//  VideoCell.m
//  PhotoCamApp
//
//  Created by Vincent Ngo on 4/20/13.
//  Copyright (c) 2013 Vincent Ngo. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

//Special initialization
//When the user clicks on a UICollectionViewCell, it will highlight the cell with a white border.
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Create a view
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        
        //Set the background color to white
        bgView.backgroundColor = [UIColor whiteColor];
        
        //Set the selectedBackgroundView to be the view you just created.
        //This basically sets the cell's background view from deselected to selected's background color. (White)
        self.selectedBackgroundView = bgView;
    }
    return self;
}


@end
