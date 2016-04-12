//
//  KFAlbumBrowser.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/8/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFAlbumBrowser.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "KFPhotoViewer.h"

@interface KFAlbumBrowser ()<UIScrollViewDelegate,KFPhotoViewerDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) NSMutableArray <KFPhotoViewer *>*photoViewerArray;
@property (nonatomic,assign) NSUInteger curIndex;
@end

@implementation KFAlbumBrowser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _hasBottomBar = NO;
        _hideStatusBar = YES;
        _startIndex = 0;
        _photoViewerArray = [NSMutableArray array];
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
    
    self.scrollView.contentSize = CGSizeMake(self.photos.count * imageWidth, imageHeight);
    [self.view addSubview:self.scrollView];

    for (NSUInteger i = 0; i < self.photos.count; i ++) {
        KFPhotoViewer *photoViewer = [[KFPhotoViewer alloc]initWithFrame:CGRectMake(i* imageWidth, 0, imageWidth, imageHeight)];
        photoViewer.vDelegate = self;
        photoViewer.backgroundColor = [UIColor blackColor];
        [self.scrollView addSubview:photoViewer];
        [self.photoViewerArray addObject:photoViewer];
    }
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, imageHeight - 20, imageWidth, 20)];
    [self.view addSubview:self.pageControl];
    
}

- (void)showStartImage{
    KFPhoto *startPhoto = self.photos[_startIndex];
    if (startPhoto.largeImage) {
        KFPhotoViewer *photoViewer = self.photoViewerArray[_startIndex];
        if (!CGRectIsEmpty(startPhoto.originalFrame)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [photoViewer makeAnimationWithImage:startPhoto.largeImage contentMode:UIViewContentModeScaleToFill fromRect:startPhoto.originalFrame];
            });
            
        }else{
            [photoViewer setImage:startPhoto.largeImage isLoading:NO];
        }
    }else{
        [self loadImageAtIndex:(NSUInteger)index];
    }
}


- (void)loadImageAtIndex:(NSUInteger)index{
    KFPhoto *photo = self.photos[index];
    KFPhotoViewer *photoViewer = self.photoViewerArray[index];
    [photoViewer setImage:photo.thumbImage isLoading:YES];
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:photo.largeUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //here loading progress
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [photoViewer setImage:image isLoading:NO];
    }];
}


//- (NSUInteger)preIndex{
//    NSUInteger pre = self.curIndex;
//    if (pre == 0) {
//        pre = self.photos.count - 1;
//    }else{
//        pre --;
//    }
//    return pre;
//}
//
//- (NSUInteger)nextIndex{
//    NSUInteger next = self.curIndex;
//    if (next == self.photos.count) {
//        next = 0;
//    }else{
//        next ++;
//    }
//    return next;
//}

//photos setter
- (void)setPhotos:(NSArray<KFPhoto *> *)photos{
    _photos = photos;
    for (NSUInteger i = 0; i < photos.count; i++) {
        KFPhoto *photo = photos[i];
        
        if (!photo.largeUrl&&!photo.largeImage) {
            //fy-todo
            return;
        }
        
        BOOL existLargeImage = [self getExistLargeImage:photo];
        
        if (existLargeImage) {
            //fy-todo
            __block KFPhoto *photo;
            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:photo.largeUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                photo.largeImage = image;
            }];
        }
    }
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
    KFPhoto *photo = self.photos[self.curIndex];
    [photoViewer dismissToRect:photo.originalFrame];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
    
}


@end
