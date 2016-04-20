//
//  KFPhoto.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/8/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFPhoto.h"


@interface KFPhoto ()
@property (nonatomic,readwrite) CGRect originalFrame;
@end

@implementation KFPhoto

- (instancetype)initWithThumbView:(UIImageView *)thumbView largeUrl:(NSString *)largeUrl
{
    self = [super init];
    if (self) {
        _thumbView = thumbView;
        _largeUrl = largeUrl;
        _originalFrame = [thumbView.superview convertRect:thumbView.frame toView:nil];
    }
    return self;
}

- (void)setThumbView:(UIImageView *)thumbView{
    _thumbView = thumbView;
    self.originalFrame = [thumbView.superview convertRect:thumbView.frame toView:nil];
}

@end

