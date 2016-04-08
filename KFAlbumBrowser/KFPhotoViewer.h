//
//  ZoomView.h
//  ZoomDemo
//
//  Created by KittyFeng on 9/17/15.
//  Copyright (c) 2015 KittyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFPhoto.h"

//typedef NS_ENUM(NSUInteger,KFPhotoAnimationType) {
//    KFPhotoAnimationTypeNone = 1,
//    KFPhotoAnimationAppear = 2,
//    KFPhotoAnimationDisappear = 3,
//};

@interface KFPhotoViewer : UIScrollView

@property (nonatomic,readonly) UIImageView *imageView;

@property (nonatomic) BOOL animationEnabled;

- (instancetype)initWithFrame:(CGRect)frame
                        photo:(KFPhoto *)photo
                showAnimation:(BOOL)animation;

- (void)scaleToOriginalSize;

@end
