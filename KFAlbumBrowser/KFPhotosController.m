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
#import "SDWebImagePrefetcher.h"

#define collectionCellIdentifier @"photoCell"

@interface KFPhotosController ()<KFPhotoCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UIViewControllerTransitioningDelegate>{
    BOOL isStarting;
}

@property (nonatomic,assign) NSUInteger curIndex;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageCtrl;
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)initViews{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    flowLayout.minimumLineSpacing = 16;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-8, 0, self.view.bounds.size.width + 16, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[KFPhotoCell class]
            forCellWithReuseIdentifier:collectionCellIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIPageControl *pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 20)];
    pageCtrl.numberOfPages = self.photos.count;
    pageCtrl.currentPage = self.startIndex;
    pageCtrl.hidesForSinglePage = YES;
    [self.view addSubview:pageCtrl];
    self.pageCtrl = pageCtrl;
    
    
}


- (void)showStartImage{
    [self.collectionView setContentOffset:CGPointMake(self.startIndex*self.view.frame.size.width + 16*self.startIndex, 0) animated:NO];
    isStarting = YES;
}

- (void)setPhotos:(NSArray<KFPhoto *> *)photos{
    for (NSUInteger i = 0; i < photos.count; i++) {
        KFPhoto *photo = photos[i];
        
        if ((!photo.largeUrl.length)&&(!photo.largeImage)) {
            photo.largeImage = photo.thumbView.image;
            continue;
        }
    }
    _photos = photos;
}


- (void)setStartIndex:(NSUInteger)startIndex{
    _startIndex = startIndex;
    self.curIndex = startIndex;
}



- (void)prefetchImagesAroundIndex:(NSUInteger)curIndex{
    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:2];
    NSInteger preIndex = curIndex - 1;
    if (preIndex >= 0) {
        [urlArray addObject:[NSURL URLWithString:self.photos[preIndex].largeUrl]];
    }
    
    NSUInteger nextIndex = curIndex + 1;
    if (nextIndex <= self.photos.count - 1 ) {
        [urlArray addObject:[NSURL URLWithString:self.photos[nextIndex].largeUrl]];
    }
    [self prefetchImageUrls:urlArray];
}

- (void)prefetchImageUrls:(NSArray *)urls{
    [[SDWebImagePrefetcher sharedImagePrefetcher]prefetchURLs:urls];
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
    [self prefetchImagesAroundIndex:indexPath.row];
    return cell;
}



#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.pageCtrl.currentPage = ceil((collectionView.contentOffset.x - (8 + 16*_curIndex))/collectionView.frame.size.width);
}


#pragma mark - KFPhotoCellDelegate

- (void)tapImage:(KFPhoto *)photo inPhotoViewer:(KFPhotoViewer *)photoViewer{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (!CGRectIsEmpty(photo.originalFrame)) {
        [photoViewer dismissToRect:photo.originalFrame animation:^{
            self.collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }];
    }
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
