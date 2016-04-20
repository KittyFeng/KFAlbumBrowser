//
//  KFAnimationController.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/13/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFPresentAnimationController.h"


@implementation KFPresentAnimationController


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    [container addSubview:toViewController.view];
    toViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [UIView animateWithDuration:self.duration delay:0 options:0 animations:^{
        toViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }  completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    } ];
    

}


@end
