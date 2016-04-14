//
//  KFAlbumBrowser.h
//  KFAlbumBrowserDemo
//  to see photos with fix pages
//  Created by KittyFeng on 4/8/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFPhoto.h"

@interface KFPhotosBrowser : UIViewController

@property (nonatomic,assign) BOOL hideStatusBar;
@property (nonatomic,assign) BOOL hasBottomBar;
@property (nonatomic,strong) NSArray <KFPhoto *> *photos;
@property (nonatomic,assign) NSUInteger startIndex;

@end
