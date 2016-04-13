//
//  KFPhoto.h
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/8/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KFPhoto : NSObject

@property (nonatomic) UIImage *thumbImage;
@property (nonatomic) NSString *largeUrl;
@property (nonatomic) UIImage *largeImage;
@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic) CGRect originalFrame;


@end
