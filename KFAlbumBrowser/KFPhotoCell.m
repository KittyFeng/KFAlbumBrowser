//
//  KFPhotoCell.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/15/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFPhotoCell.h"
#import "KFPhoto.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@interface KFPhotoCell ()
@property (nonatomic) KFPhoto *photo;
@end

@implementation KFPhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _photoViewer = [[KFPhotoViewer alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        typeof(self) __weak wSelf = self;
        _photoViewer.tapBlock = ^(KFPhotoViewer * photoViewer){
            [wSelf tapPhoto:photoViewer];
        };
        [self addSubview:_photoViewer];
    }
    return self;
}


- (void)setPhoto:(KFPhoto *)photo startShow:(BOOL)isStarting{
    [self.photoViewer scaleToOriginalSize];
    _photo = photo;
    _photoViewer.imageMode = photo.thumbView.contentMode;
    
    [self showPhoto:photo isStarting:isStarting];
}

- (void)showPhoto:(KFPhoto *)photo isStarting:(BOOL)isStarting{
    if (isStarting) {
        [self showStartImage:photo];
    }else{
        [self showCommonImage:photo];
    }
}


- (BOOL)existInDisk:(KFPhoto *)photo{
    return [[SDWebImageManager sharedManager]diskImageExistsForURL:[NSURL URLWithString:photo.largeUrl]];
}

- (void)showStartImage:(KFPhoto *)photo{
    if (photo.largeImage) {
        [self.photoViewer makeAnimationWithImage:photo.largeImage fromRect:photo.originalFrame];
    }else if([self existInDisk:photo]){
        [self.photoViewer setImage:nil withFrame:photo.originalFrame animation:NO];
        [self.photoViewer.imageView sd_setImageWithURL:[NSURL URLWithString:photo.largeUrl] placeholderImage:photo.thumbView.image options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.photoViewer setImage:nil animation:YES];
        }];
    }else{
        [self requestLargeImage:photo];
    }
}

- (void)showCommonImage:(KFPhoto *)photo{
    if (photo.largeImage) {
        [self.photoViewer setImage:photo.largeImage animation:NO];
    }else{
        [self requestLargeImage:photo];
    }
}


- (void)requestLargeImage:(KFPhoto *)photo{
    if (!photo.largeUrl) {
        return;
    }
    
    [self.photoViewer setImage:nil withSize:photo.originalFrame.size animation:NO];
    
    BOOL exist = [[SDWebImageManager sharedManager]diskImageExistsForURL:[NSURL URLWithString:photo.largeUrl]];
    
    [self.photoViewer startLoadingWithHud:!exist];
    
    [self.photoViewer.imageView sd_setImageWithURL:[NSURL URLWithString:photo.largeUrl] placeholderImage:photo.thumbView.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (expectedSize>0) {
            [self.photoViewer setLoadingProgress:receivedSize/expectedSize];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.photoViewer setImage:image animation:!exist];
            photo.largeImage = image;
        }
        
        [self.photoViewer stopLoading];
        
    }];
    
}


- (void)tapPhoto:(KFPhotoViewer *)photoViewer{
    if ([self.delegate respondsToSelector:@selector(tapImage:inPhotoViewer:)]) {
        [self.delegate tapImage:self.photo inPhotoViewer:self.photoViewer];
    }
}

@end
