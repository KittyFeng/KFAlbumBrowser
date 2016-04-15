//
//  KFPhotosController.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/15/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFPhotosController.h"
#import "KFPhotoCell.h"
#import "SDWebImageManager.h"
#import "KFDismissAnimationController.h"
#import "KFPresentAnimationController.h"

#define collectionCellIdentifier @"photoCell"

@interface KFPhotosController ()<KFPhotoCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UIViewControllerTransitioningDelegate>{
    BOOL isStarting;
}

@property (nonatomic,assign) NSUInteger curIndex;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation KFPhotosController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        _startIndex = 0;
        _curIndex = 0;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
    [self showStartImage];
}


- (void)initViews{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width , self.view.bounds.size.height);
    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumLineSpacing = 0;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
//    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-5, 0, self.view.bounds.size.width + 10, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    [self.collectionView registerClass:[KFPhotoCell class]
            forCellWithReuseIdentifier:collectionCellIdentifier];
    [self.view addSubview:self.collectionView];
}


- (void)showStartImage{
    [self.collectionView setContentOffset:CGPointMake(self.startIndex*self.view.frame.size.width, 0) animated:NO];
    self.curIndex = _startIndex;
    isStarting = YES;
}

- (void)setPhotos:(NSArray<KFPhoto *> *)photos{
    for (NSUInteger i = 0; i < photos.count; i++) {
        KFPhoto *photo = photos[i];
        
        if ((!photo.largeUrl.length)&&(!photo.largeImage)) {
            photo.largeImage = photo.thumbImage;
            continue;
        }
        
        BOOL existLargeImage = [self getExistLargeImage:photo];
        
        if (!existLargeImage) {
            //fy-todo
            __block KFPhoto *photo;
            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:photo.largeUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                photo.largeImage = image;
            }];
        }
    }
    _photos = photos;
}



//judge if large image exists on disk or memory,and set the image it to photo model
- (BOOL)getExistLargeImage:(KFPhoto *)photo{
    if (photo.largeImage) {
        return  YES;
    }else{
        if (photo.largeUrl.length) {
            BOOL exist = [[SDWebImageManager sharedManager]diskImageExistsForURL:[NSURL URLWithString:photo.largeUrl]];
            if (exist) {
                photo.largeImage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[NSURL URLWithString:photo.largeUrl].absoluteString];
            }
            return exist;
        }
        return NO;
    }
}



#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KFPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell setPhoto:self.photos[indexPath.row] startShow:(BOOL)isStarting];
    cell.multipleTouchEnabled = YES;
    if (isStarting) {
        isStarting = NO;
    }
    
    return cell;
}


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}


#pragma mark - UICollectionCellDelegate
- (void)requestImage:(KFPhoto *)photo inPhotoViewer:(KFPhotoViewer *)photoViewer{
    if (!photo.largeUrl.length) {
        return;
    }
    [photoViewer setImage:photo.thumbImage isLoading:YES];
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:photo.largeUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //here loading progress
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [photoViewer setImage:image isLoading:NO];
        photo.largeImage = image;
    }];

}

- (void)tapImage:(KFPhoto *)photo inPhotoViewer:(KFPhotoViewer *)photoViewer{
    [photoViewer dismissToRect:photo.originalFrame animation:^{
        self.collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    KFPresentAnimationController *animationController = [[KFPresentAnimationController alloc]init];
    animationController.duration = 0.3;
    animationController.options = UIViewAnimationOptionCurveEaseOut;
    return animationController;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    KFDismissAnimationController *animationController = [[KFDismissAnimationController alloc]init];
    animationController.duration = 0.3;
    animationController.options = UIViewAnimationOptionCurveEaseOut;
    return animationController;
}
@end
