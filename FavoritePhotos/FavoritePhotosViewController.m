//
//  FavoritePhotosViewController.m
//  FavoritePhotos
//
//  Created by Chris Snyder on 8/11/14.
//  Copyright (c) 2014 Chris Snyder. All rights reserved.
//

#import "FavoritePhotosViewController.h"
#import "FavoritePhotoCell.h"

@interface FavoritePhotosViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *favoritesView;

@end

@implementation FavoritePhotosViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.favoriteImages.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FavoritePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"favoriteCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                                                 [self.favoriteImages objectAtIndex:indexPath.row]]]];
    
    
    return cell;
}

@end
