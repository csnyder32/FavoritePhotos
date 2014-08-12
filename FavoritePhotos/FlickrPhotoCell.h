//
//  FlickrPhotoCell.h
//  FavoritePhotos
//
//  Created by Chris Snyder on 8/11/14.
//  Copyright (c) 2014 Chris Snyder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteView;

@property BOOL isSelected;

@end
