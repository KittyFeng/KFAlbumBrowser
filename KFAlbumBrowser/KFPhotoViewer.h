//
//  ZoomView.h
//  ZoomDemo
//
//  Created by KittyFeng on 9/17/15.
//  Copyright (c) 2015 KittyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFPhoto.h"


@class KFPhotoViewer;

@protocol KFPhotoViewerDelegate<NSObject>

@optional
- (void)tapPhotoViewer:(KFPhotoViewer *)photoViewer;

@end

@interface KFPhotoViewer : UIScrollView

@property (nonatomic,readonly) UIImageView *imageView;
@property (nonatomic,weak) id <KFPhotoViewerDelegate> vDelegate;
@property (nonatomic,assign) UIViewContentMode imageMode;


- (void)makeAnimationWithImage:(UIImage *)largeImage
                      fromRect:(CGRect)rect;

- (void)dismissToRect:(CGRect)rect;

    
- (void)setImage:(UIImage *)image isLoading:(BOOL)isLoading;

- (void)scaleToOriginalSize;



@end
