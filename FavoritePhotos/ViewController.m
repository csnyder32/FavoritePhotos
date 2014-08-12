//
//  ViewController.m
//  FavoritePhotos
//
//  Created by Chris Snyder on 8/11/14.
//  Copyright (c) 2014 Chris Snyder. All rights reserved.
//

#import "ViewController.h"
#import "FlickrPhotoCell.h"
#import "FavoritePhotosViewController.h"
#define flickrAPIKey @"17ce6d25088d5a1ef6571fe5e6f02c95"


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property NSString *searchString;
@property NSArray *flickrPhotosArray;
@property NSMutableArray *flickrPhotoURLs;
@property NSMutableArray *flickrFavs;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];

    if (self.flickrFavs == nil) {
        self.flickrFavs = [NSMutableArray new];
    }

}


-(void)getPhotosFromFlickr
{
    NSURL *searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@e&sort=relevance&safe_search=2&extras=url_m&per_page=10&format=json&nojsoncallback=1", flickrAPIKey, self.searchString]];
    NSURLRequest *flickrRequest = [NSURLRequest requestWithURL:searchURL];
    [NSURLConnection sendAsynchronousRequest:flickrRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        self.flickrPhotosArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"photos"][@"photo"];
        self.flickrPhotoURLs = [NSMutableArray arrayWithCapacity:self.flickrPhotosArray.count];

        for (NSDictionary *photo in self.flickrPhotosArray)
        {
            NSNumber *farm = photo[@"farm"];
            NSString *eyedee = photo[@"id"];
            NSString *secret = photo[@"secret"];
            NSString *server = photo[@"server"];
            NSString *photoURL = [NSString stringWithFormat: @"http://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, server, eyedee, secret];
            [self.flickrPhotoURLs addObject:photoURL];
        }
        [self.collectionView reloadData];
    }];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                        [self.flickrPhotoURLs objectAtIndex:indexPath.row]]]];
    

    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.flickrPhotoURLs.count > 10) {
        return 10;
    }else{
        return self.flickrPhotoURLs.count;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhotoCell *cell = (FlickrPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.isSelected) {
        cell.backgroundColor = [UIColor yellowColor];
        cell.isSelected = YES;
        cell.favoriteView.image = [UIImage imageNamed:@"thumbs"];
        [self.flickrFavs addObject:cell.imageView.image];
        NSLog(@"%@", self.flickrFavs);
    }else{
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        cell.backgroundColor = [UIColor blackColor];
        cell.favoriteView.image = nil;
        [self.flickrFavs removeObject:cell.imageView.image];
        cell.isSelected = NO;
    }
}
- (IBAction)onSearchButtonPressed:(id)sender
{
    self.searchString = self.searchBar.text;
    [self getPhotosFromFlickr];
    [self.searchBar resignFirstResponder];
}
-(NSURL *) documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directories = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSLog(@"%@", directories.firstObject);
    return  directories.firstObject;
}
-(void)save
{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes.plist" ];
    NSLog(@"%@", plist);
    [self.flickrFavs writeToURL:plist atomically:YES];
}
-(void)load
{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes.plist" ];
    self.flickrFavs = [NSMutableArray arrayWithContentsOfURL:plist];
}

- (IBAction)onFavoritesTapped:(id)sender
{
    [self performSegueWithIdentifier:@"favoriteSegue" sender:self];
   
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"favoriteSegue"]) {
    FavoritePhotosViewController *vc = (FavoritePhotosViewController *)segue.destinationViewController;
    vc.favoriteImages = self.flickrFavs;
    }

}

@end
