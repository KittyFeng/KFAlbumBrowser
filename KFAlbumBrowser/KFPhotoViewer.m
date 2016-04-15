//
//  ZoomView.m
//  ZoomDemo
//
//  Created by KittyFeng on 9/17/15.
//  Copyright (c) 2015 KittyFeng. All rights reserved.
//

#import "KFPhotoViewer.h"
#import "KFPhoto.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"


@interface KFPhotoViewer ()<UIScrollViewDelegate>{
    
    CGFloat maxZoomScale;
    CGFloat minZoomScale;

}

@property (nonatomic,readwrite) UIImageView *imageView;
@property (nonatomic,assign) BOOL isLoading;



@end

@implementation KFPhotoViewer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self addImageView];
    }
    return self;
}

- (void)setup{
    maxZoomScale = 2;
    minZoomScale = 1;
    self.delegate = self;
    self.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomInAndOut:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTap];
}

- (void)addImageView{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _imageView.contentMode = _imageMode;
    _imageMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
}

- (void)photoTap{
    if (self.tapBlock) {
        self.tapBlock(self);
    }
    if ([self.vDelegate respondsToSelector:@selector(tapPhotoViewer:)]) {
        [self.vDelegate tapPhotoViewer:self];
    }
}


- (void)zoomInAndOut:(UIGestureRecognizer *)doubleTap{
    if (self.zoomScale == 1) {
        CGPoint point = [doubleTap locationInView:self];
        [self zoomToRect:CGRectMake(point.x-40, point.y-40 , 80, 80) animated:YES];
    }else{
        self.zoomScale = 1;
    }
}

- (void)makeAnimationWithImage:(UIImage *)largeImage
                      fromRect:(CGRect)rect{
    
    self.imageView.frame = [self convertRect:rect fromView:nil];
    self.imageView.image = largeImage;
    
    CGRect newFrame = [self getRightFrameOfImage:largeImage InRect:self.bounds];
    
    [self resizePhotoToRect:newFrame contentMode:UIViewContentModeScaleAspectFit animation:^{
        self.backgroundColor = [UIColor blackColor];
    } completion:^{
        [self unlockZoom];
    }];
    
}




- (void)setImage:(UIImage *)image isLoading:(BOOL)isLoading{
    if (isLoading) {
        [self setLoadingImage:image];
        [self lockZoom];
    }else{
        [self setLargeImage:image];
        [self unlockZoom];
    }
}


- (void)setLoadingImage:(UIImage *)image{
    _isLoading = YES;
    self.imageView.image = image;
    self.imageView.frame = [self getThumbnailRect];
}

- (void)setLargeImage:(UIImage *)image{
    self.imageView.image = image;
    
    CGRect newFrame = [self getRightFrameOfImage:image InRect:self.bounds];
    if (_isLoading) {
        [self resizePhotoToRect:newFrame contentMode:UIViewContentModeScaleAspectFit animation:nil completion:nil];
    }else{
        self.imageView.frame = newFrame;
    }
    _isLoading = NO;
}

- (CGRect)getThumbnailRect{
    return CGRectMake(self.bounds.size.width/2.0 - 50, self.bounds.size.height/2.0 - 80, 100, 100);
}



#pragma mark - reize Image View

- (CGRect)getRightFrameOfImage:(UIImage *)image InRect:(CGRect)rect{
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGRect rightFrame;
    if (imageHeight/imageWidth > height/width) {
        CGFloat newWidth = (imageWidth/imageHeight)*height;
        rightFrame = CGRectMake(width/2.0-newWidth/2.0, 0, newWidth, height);
    }else{
        CGFloat newHeight = (imageHeight/imageWidth)*width;
        rightFrame = CGRectMake(0, height/2.0 -newHeight/2.0 , width, newHeight);
    }
    
    return rightFrame;
}


- (void)resizePhotoToRect:(CGRect )frame contentMode:(UIViewContentMode)contentMode animation:(void (^)(void))animation completion:(void (^)(void))completion{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.imageView.contentMode = contentMode;
        self.imageView.frame = frame;
        if (animation) {
            animation();
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if (completion) {
                 completion();
            }
        }
    }];
    
}





- (void)dismissToRect:(CGRect)rect animation:(void (^)(void))animation{
    [self resizePhotoToRect:[self convertRect:rect fromView:nil] contentMode:self.contentMode animation:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.superview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        animation();
    } completion:nil];
}

- (void)scaleToOriginalSize{
    self.zoomScale = 1;
}

#pragma mark - scroll view delegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize scrollSize = scrollView.bounds.size;
    CGRect imgViewFrame = self.imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // 竖着长的 就是垂直居中
    if (imgViewFrame.size.width <= scrollSize.width)
    {
        centerPoint.x = scrollSize.width/2;
    }
    
    // 横着长的  就是水平居中
    if (imgViewFrame.size.height <= scrollSize.height)
    {
        centerPoint.y = scrollSize.height/2;
    }
    
    self.imageView.center = centerPoint;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}


#pragma mark - lock zoom

-(void)lockZoom
{
    
    self.maximumZoomScale = 1.0;
    self.minimumZoomScale = 1.0;
}

-(void)unlockZoom
{
    
    self.maximumZoomScale = maxZoomScale;
    self.minimumZoomScale = minZoomScale;
    
}

#pragma mark - setter

- (void)setImageMode:(UIViewContentMode)imageMode{
    self.imageView.contentMode = imageMode;
    _imageMode = imageMode;
}



@end
