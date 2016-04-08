//
//  KFAlbumBrowser.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/8/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFAlbumBrowser.h"

@interface KFAlbumBrowser ()

@property (nonatomic) UIScrollView *scrollView;

@end

@implementation KFAlbumBrowser

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hasBottomBar = NO;
        _hideStatusBar = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
}


- (void)initViews{
    CGRect frame = self.view.frame;
    
    CGFloat bottomBarHeight = 44;
    
    if (self.hasBottomBar) {
        CGFloat heihgt = frame.size.height - bottomBarHeight;
        frame.size.height = heihgt;
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
    
}

@end
