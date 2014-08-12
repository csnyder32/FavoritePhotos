//
//  FavoritePhotosViewController.m
//  FavoritePhotos
//
//  Created by Chris Snyder on 8/11/14.
//  Copyright (c) 2014 Chris Snyder. All rights reserved.
//

#import "FavoritePhotosViewController.h"

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
    return  0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


@end
