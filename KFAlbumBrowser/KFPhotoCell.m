//
//  KFPhotoCell.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/15/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFPhotoCell.h"
#import "KFPhoto.h"

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
    _photoViewer.imageMode = photo.contentMode;
    if (isStarting) {
        [self showStartImage:photo];
    }else{
        [self setImage:photo];
    }
}


- (void)showStartImage:(KFPhoto *)photo{
    if (photo.largeImage) {
        if (!CGRectIsEmpty(photo.originalFrame)) {
            [_photoViewer makeAnimationWithImage:photo.largeImage fromRect:photo.originalFrame];
        }else{
            [_photoViewer setImage:photo.largeImage isLoading:NO];
        }
        
    }else{
        [self requestImage:photo];
    }
}

- (void)setImage:(KFPhoto *)photo{
    if (photo.largeImage) {
        [_photoViewer setImage:photo.largeImage isLoading:NO];
    }else{
        [self requestImage:photo];
    }
}


- (void)requestImage:(KFPhoto *)photo{
    if ([self.delegate respondsToSelector:@selector(requestImage:inPhotoViewer:)]) {
        [self.delegate requestImage:photo inPhotoViewer:_photoViewer];
    }
}


- (void)tapPhoto:(KFPhotoViewer *)photoViewer{
    if ([self.delegate respondsToSelector:@selector(tapImage:inPhotoViewer:)]) {
        [self.delegate tapImage:self.photo inPhotoViewer:self.photoViewer];
    }
}

@end
