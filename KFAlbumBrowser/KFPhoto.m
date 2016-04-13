//
//  KFPhoto.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/8/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFPhoto.h"

@implementation KFPhoto

- (instancetype)initWithOriginalFrame:(CGRect)originalFrame
                           thumbImage:(UIImage *)thumbImage
                             largeUrl:(NSString *)largeUrl
{
    self = [super init];
    if (self) {
        _largeUrl = largeUrl;
        _originalFrame = originalFrame;
        _thumbImage = thumbImage;
    }
    return self;
}




//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}

@end
