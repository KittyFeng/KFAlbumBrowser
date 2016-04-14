//
//  KFAlbumBrowser.m
//  KFAlbumBrowserDemo
//  to see photos with infinte slides
//  Created by KittyFeng on 4/14/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFAlbumBrowser.h"
#import "KFPhotoViewer.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

#define kMaxArrayCount 100000
@interface  KFAlbumBrowser ()<UIScrollViewDelegate>{
    CGFloat lastOffset;
}

@property (nonatomic,strong) KFPhotoViewer *reusedPhotoViewer;
//相册当前页
@property (nonatomic,readwrite) NSUInteger page;
//相册总相片数
@property (nonatomic,readwrite) NSUInteger total;
@property (nonatomic,strong) UIScrollView *scrollView;
//当前持有的photos的index
@property (nonatomic,assign) NSInteger curIndex;
@property (nonatomic,strong) NSMutableArray *photoViewerArray;
@property (nonatomic,assign) NSInteger targetIndex;
@property (nonatomic,assign) BOOL rightDirection;
@end

@implementation KFAlbumBrowser

- (instancetype)init
{
    self = [super init];
    if (self) {
        _curIndex = 0;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
    [self showFirstImage];
}

- (void)initViews{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*self.photos.count, scrollView.frame.size.height);
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width*self.curIndex, 0);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    KFPhotoViewer *photoViewer = [[KFPhotoViewer alloc]initWithFrame:CGRectMake(scrollView.frame.size.width*self.curIndex, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    [scrollView addSubview:photoViewer];

}

- (void)showFirstImage{
    
}


#pragma mark - setter
- (void)setPhotos:(NSMutableArray *)photos{
    if(photos.count > kMaxArrayCount){
        return;
    }
    _photos = photos;
}




#pragma mark - public methods

- (void)appendPhotos:(NSArray *)photos{
    if (photos.count > kMaxArrayCount) {
        return;
    }
    NSUInteger contain = _photos.count + photos.count;
    if (contain > kMaxArrayCount) {
        NSUInteger exceed = contain - kMaxArrayCount;
        [_photos removeObjectsInRange:NSMakeRange(0, exceed)];
    }
    [_photos addObjectsFromArray:photos];
}


- (void)insertPhotosInFront:(NSArray <NSString *>*)photos{
    if (photos.count > kMaxArrayCount) {
        return;
    }
    NSUInteger contain = _photos.count + photos.count;
    _curIndex += photos.count;
    if (contain > kMaxArrayCount){
        NSUInteger exceed = contain - kMaxArrayCount;
        [_photos removeObjectsInRange:NSMakeRange(_photos.count - exceed, exceed)];
    }
    [_photos insertObjects:photos atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)]];
}


#pragma mark - pravite methods

- (void)downloadImageAroundIndex:(NSUInteger)curIndex{
    NSInteger preIndex = [self preIndex];
    if (preIndex < 0) {
        [self loadPre];
    }else{
        [self loadImageAtIndex:[self preIndex]];
    }
    
    NSInteger nextIndex = [self nextIndex];
    if (nextIndex < 0 ) {
        [self  loadAfter];
    }else{
        [self loadImageAtIndex:[self nextIndex]];
    }
}

- (void)loadImageAtIndex:(NSInteger)index{
    if (index < 0) {
        return;
    }
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:self.photos[index]] options:SDWebImageRetryFailed progress:nil completed:nil];
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


//当访问数组以外的内容,delegate??
- (void)loadPre{
    
}

- (void)loadAfter{

}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = -1;
    if(scrollView.contentOffset.x - lastOffset > 0){
        self.rightDirection = YES;
        index = [self nextIndex];
    }else if (scrollView.contentOffset.x - lastOffset < 0){
        self.rightDirection = NO;
        index = [self preIndex];
    }

    if (index >= 0 &&index!=_curIndex&&index!=_targetIndex) {
        self.targetIndex = index;
        [self addPhotoViewerAtIndex:index];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint point = *targetContentOffset;
    NSUInteger page = point.x/scrollView.frame.size.width;
    if (self.curIndex != page)
    {
        self.curIndex = page;
    }
}


- (void)addPhotoViewerAtIndex:(NSInteger)index{
    if (index < -1) {
        return;
    }
    KFPhotoViewer *photoViewer = self.reusedPhotoViewer;
    if (!photoViewer) {
        photoViewer = [[KFPhotoViewer alloc]initWithFrame:CGRectMake(index*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    }
    
    if (self.photoViewerArray.count >= 3) {
        if (self.rightDirection) {
            self.reusedPhotoViewer = self.photoViewerArray[0];
            [self.reusedPhotoViewer removeFromSuperview];
            [self.photoViewerArray removeObjectAtIndex:0];
        }else{
            self.reusedPhotoViewer = self.photoViewerArray.lastObject;
            [self.reusedPhotoViewer removeFromSuperview];
            [self.photoViewerArray removeLastObject];
        }
        
    }
    [self.photoViewerArray addObject:photoViewer];
    [self.scrollView addSubview:photoViewer];
    
}

- (void)setImageUrl:(NSString *)url inPhotoViewer:(KFPhotoViewer *)photoViewer{
    [photoViewer setImage:nil isLoading:YES];
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //here loading progress
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        //cancel loading
        if (image&&finished) {
            [photoViewer setImage:image isLoading:NO];
        }else{
            //show failure
            [photoViewer setImage:nil isLoading:NO];
        }
        
    }];
}


@end
