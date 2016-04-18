//
//  KFAlbumBrowser.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/8/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFPhotosBrowser.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "KFPhotoViewer.h"
#import "KFPresentAnimationController.h"
#import "KFDismissAnimationController.h"

@interface KFPhotosBrowser ()<UIScrollViewDelegate,KFPhotoViewerDelegate,UIViewControllerTransitioningDelegate>{
    CGFloat lastOffset;
    NSInteger targetIndex;
}

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) NSMutableArray <KFPhotoViewer *>*photoViewerArray;
@property (nonatomic,assign) NSUInteger curIndex;
@end

@implementation KFPhotosBrowser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        _hasBottomBar = NO;
        _hideStatusBar = YES;
        _startIndex = 0;
        _curIndex = _startIndex;
        _photoViewerArray = [NSMutableArray array];
        targetIndex = -1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
    [self showStartImage];
}


- (void)initViews{
    CGRect frame = self.view.frame;
    CGFloat bottomBarHeight = 44;
    
    if (self.hasBottomBar) {
        CGFloat heihgt = frame.size.height - bottomBarHeight;
        frame.size.height = heihgt;
    }
    
    CGFloat imageWidth = frame.size.width;
    CGFloat imageHeight = frame.size.height;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.contentSize = CGSizeMake(self.photos.count * imageWidth, imageHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    for (NSUInteger i = 0; i < self.photos.count; i ++) {
        KFPhotoViewer *photoViewer = [[KFPhotoViewer alloc]initWithFrame:CGRectMake(i* imageWidth, 0, imageWidth, imageHeight)];
        photoViewer.vDelegate = self;
        photoViewer.imageMode = self.photos[i].contentMode;
        [self.scrollView addSubview:photoViewer];
        [self.photoViewerArray addObject:photoViewer];
    }
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, imageHeight - 20, imageWidth, 20)];
    [self.view addSubview:self.pageControl];
    
}

- (void)showStartImage{
    _curIndex = _startIndex;
    KFPhoto *startPhoto = self.photos[_startIndex];
    KFPhotoViewer *photoViewer = self.photoViewerArray[_startIndex];
    lastOffset = photoViewer.frame.size.width*_startIndex;
    self.scrollView.contentOffset = CGPointMake(lastOffset, 0);
    if (startPhoto.largeImage) {
        if (!CGRectIsEmpty(startPhoto.originalFrame)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [photoViewer makeAnimationWithImage:startPhoto.largeImage fromRect:startPhoto.originalFrame];
            });
            
        }else{
            [photoViewer setImage:startPhoto.largeImage isLoading:NO];
        }
    }else{
        [self loadImageAtIndex:(NSUInteger)_startIndex];
    }
}


- (void)loadImageAtIndex:(NSUInteger)index{
    KFPhoto *photo = self.photos[index];
    if (!photo.largeUrl.length) {
        return;
    }
    KFPhotoViewer *photoViewer = self.photoViewerArray[index];
    [photoViewer setImage:photo.thumbImage isLoading:YES];
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:photo.largeUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //here loading progress
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [photoViewer setImage:image isLoading:NO];
    }];
}


- (void)setImageAtIndex:(NSUInteger)index{
    KFPhoto *photo = self.photos[index];
    KFPhotoViewer *photoViewer = self.photoViewerArray[index];
    if (photo.largeImage) {
        [photoViewer setImage:photo.largeImage isLoading:NO];
    }else if (photo.largeUrl.length) {
        [photoViewer setImage:photo.thumbImage isLoading:YES];
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:photo.largeUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //here loading progress
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [photoViewer setImage:image isLoading:NO];
        }];
    }
    
}


- (NSInteger)preIndex{
    NSInteger pre = self.curIndex;
    if (pre == 0) {
        pre = -1;
    }else{
        pre --;
    }
    return pre;
}

- (NSInteger)nextIndex{
    NSInteger next = self.curIndex;
    if (next == self.photos.count - 1) {
        next = -1;
    }else{
        next ++;
    }
    return next;
}

//photos setter
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


#pragma mark - KFPhotoViewer delegate
- (void)tapPhotoViewer:(KFPhotoViewer *)photoViewer{
//    KFPhoto *photo = self.photos[self.curIndex];
//    [photoViewer dismissToRect:photo.originalFrame];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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


#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = -1;
    CGFloat pageWidth = scrollView.frame.size.width;
    if(scrollView.contentOffset.x - lastOffset > 20){
        index = scrollView.contentOffset.x/pageWidth + 1;
    }else if (scrollView.contentOffset.x - lastOffset < 20){
        index = scrollView.contentOffset.x/pageWidth;
    }
    if ((index >= 0&&index<=self.photos.count-1) &&(index!=_curIndex)&&(targetIndex != index)) {
        targetIndex = index;
        [self setImageAtIndex:index];
    }
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint target = *targetContentOffset;
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = target.x/pageWidth; // page编号从0开始
    
    if (self.curIndex != page)
    {
        self.curIndex = page;
        lastOffset = pageWidth*page;

    }
}




@end
