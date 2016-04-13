//
//  KFAnimationController.h
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/13/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KFPresentAnimationController :NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) UIViewAnimationOptions options;


@end
