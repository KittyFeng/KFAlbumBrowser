//
//  KFDismissAnimationController.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/13/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFDismissAnimationController.h"

@implementation KFDismissAnimationController

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:self.duration delay:0 options:0 animations:^{
        fromViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [transitionContext completeTransition:YES];
    }];
}

@end
