//
//  KFPhotosController.h
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/15/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFPhoto.h"

@interface KFPhotosController : UIViewController


@property (nonatomic,strong) NSArray <KFPhoto *>*photos;
@property (nonatomic,assign) NSUInteger startIndex;


@end
