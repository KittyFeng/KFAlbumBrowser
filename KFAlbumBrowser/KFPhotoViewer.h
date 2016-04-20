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

typedef void(^KFPhotoTap)(KFPhotoViewer *photoViewer);


@interface KFPhotoViewer : UIScrollView

@property (nonatomic,readonly) UIImageView *imageView;
@property (nonatomic,weak) id <KFPhotoViewerDelegate> vDelegate;
@property (nonatomic,assign) UIViewContentMode imageMode;
@property (nonatomic,copy) KFPhotoTap tapBlock;


- (void)makeAnimationWithImage:(UIImage *)largeImage
                      fromRect:(CGRect)rect;


- (void)dismissToRect:(CGRect)rect animation:(void (^)(void))animation;


//默认为充满屏幕大小
- (void)setImage:(UIImage *)image animation:(BOOL)animation;

//默认图片在中心
- (void)setImage:(UIImage *)image withSize:(CGSize)size animation:(BOOL)animation;

- (void)setImage:(UIImage *)image withFrame:(CGRect)frame animation:(BOOL)animation;


- (void)startLoadingWithHud:(BOOL)hasHud;
- (void)stopLoading;
- (void)setLoadingProgress:(CGFloat)progress;


- (void)scaleToOriginalSize;



@end
