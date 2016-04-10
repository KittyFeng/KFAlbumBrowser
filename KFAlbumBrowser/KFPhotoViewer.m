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

//typedef NS_ENUM(NSUInteger,ImageMode){
//    ImageModeLoading = 1,
//    ImageModeFinishLoading = 2,
//};

@interface KFPhotoViewer ()<UIScrollViewDelegate>{
    
    CGFloat maxZoomScale;
    CGFloat minZoomScale;

}

@property (nonatomic,readwrite) UIImageView *imageView;
//@property (nonatomic) KFPhoto *photo;
@property (nonatomic,assign) BOOL animation;
//@property ImageMode imageMode;

@property (nonatomic,assign) BOOL isLoading;



@end

@implementation KFPhotoViewer

//- (instancetype)initWithFrame:(CGRect)frame{
//    return [self initWithFrame:frame
//                         photo:nil
//                 showAnimation:YES];
//}
//
//
//- (instancetype)initWithFrame:(CGRect)frame
//                        photo:(KFPhoto *)photo
//                showAnimation:(BOOL)animation{
//    if (self = [super initWithFrame:frame]) {
//        _photo = photo;
//        _animation = animation;
//
//        [self setup];
//        
//        [self addImageView];
//        
//        [self loadPhoto:_photo];
//    }
//    return self;
//}


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
    maxZoomScale = 10;
    minZoomScale = 1;
    self.delegate = self;
}

- (void)addImageView{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor grayColor];
    [self addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}

- (void)photoTap{
    if ([self.vDelegate respondsToSelector:@selector(tapPhotoViewer:)]) {
        [self.vDelegate tapPhotoViewer:self];
    }
}

- (void)makeAnimationWithImage:(UIImage *)largeImage fromRect:(CGRect)rect{
    self.imageView.frame = rect;
    self.imageView.image = largeImage;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.imageView.frame = [self getRightFrameOfImage:largeImage InRect:self.bounds];
    } completion:nil];
}





- (void)setImage:(UIImage *)image isLoading:(BOOL)isLoading{
    if (isLoading) {
        [self setLoadingImage:image];
    }else{
        [self setLargeImage:image];
    }
}


- (void)setLoadingImage:(UIImage *)image{
    _isLoading = YES;
    self.imageView.image = image;
    [self resizePhotoToRect:[self getThumbnailRect] animation:NO];
}

- (void)setLargeImage:(UIImage *)image{
    BOOL animation = _isLoading;
    self.imageView.image = image;
    [self resizePhotoToRect:[self getThumbnailRect] animation:animation];
    _isLoading = NO;

}

- (CGRect)getThumbnailRect{
    return CGRectMake(self.center.x - 50, self.center.y - 50, 100, 100);
}

// deal with exist large image, return yes if it exists
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

//- (void)showImage{
//    if (self.imageMode == ImageModeFinishLoading) {
//        [self resetImage:self.photo.largeImage inView:self];
//    }else{
//        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:self.photo.largeUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            CGFloat complete = 0;
//            if (expectedSize>0) {
//                complete = receivedSize/expectedSize;
//            }
//            [self setLoadingSate:complete];
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            self.photo.largeImage = image;
//            [self setFinishLoadingState];
//        }];
//    }
//}





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

//- (void)resizePhotoToSize:(CGSize )size animation:(BOOL)animation{
//    CGRect newFrame = CGRectMake(self.center.x - size.width/2.0, self.center.y - size.height/2.0, size.width, size.height);
//    [self resizePhotoToRect:newFrame animation:animation];
//}

- (void)resizePhotoToRect:(CGRect )frame animation:(BOOL)animation{
    if(animation){
        self.imageView.frame = frame;
    }else{
        [UIView animateWithDuration:1.f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.imageView.frame = frame;
        } completion:nil];
    }
}

//- (void)loadPhoto:(KFPhoto *)photo{
//    
//    if (!photo||(!photo.largeUrl&&!photo.largeImage)) {
//        return;
//    }
//    
//    BOOL existLargeImage = [self getExistLargeImage:photo];
//    
//    if (existLargeImage) {
//        [self setFinishLoadingState];
//    }else{
//        [self setLoadingSate:0];
//        
//    }
//
//}


//- (void)setFinishLoadingState{
//    self.imageMode = ImageModeFinishLoading;
//    [self unlockZoom];
//}
//
//
//- (void)setLoadingSate:(CGFloat)progress{
//    self.imageMode = ImageModeLoading;
//    [self lockZoom];
//}


//
//- (void)previewImageWithPhoto:(KFPhoto *)photo{
//    if (photo.largeImage) {
//        return;
//    }
//    
//    if (photo.thumbImage) {
//        //deal with preview
//    }
//}





//- (void)resetImage:(UIImage *)image inView:(UIView *)superView{
//    
//    CGFloat height = superView.frame.size.height;
//    CGFloat width = superView.frame.size.width;
//    
//    CGFloat imageWidth = image.size.width;
//    CGFloat imageHeight = image.size.height;
//   
//    if (imageHeight/imageWidth > height/width) {
//        CGFloat newWidth = (imageWidth/imageHeight)*height;
//        _imageView.frame = CGRectMake(width/2.0-newWidth/2.0, 0, newWidth, height);
//    }else{
//        CGFloat newHeight = (imageHeight/imageWidth)*width;
//        _imageView.frame = CGRectMake(0, height/2.0 -newHeight/2.0 , width, newHeight);
//    }
//    
//    _imageView.image = image;
//    
//}

//- (void)setPhoto:(KFPhoto *)photo{
//    _photo = photo;
//    [self loadPhoto:photo];
//}
//
//
//- (void)scaleToOriginalSize{
//    self.zoomScale = 1;
//}

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





@end
