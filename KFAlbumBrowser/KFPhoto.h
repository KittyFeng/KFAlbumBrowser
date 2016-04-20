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

@property (nonatomic,strong) UIImageView *thumbView;
@property (nonatomic,copy) NSString *largeUrl;
@property (nonatomic,strong) UIImage *largeImage;

@property (nonatomic,readonly) CGRect originalFrame;


@end
