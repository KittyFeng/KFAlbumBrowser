//
//  KFAlbumBrowser.h
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/14/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KFAlbumBrowserDelegate <NSObject>
@optional
//- (void)

@end

@interface KFAlbumBrowser : UIViewController

@property (nonatomic,strong) NSMutableArray<NSString *> *photos;
@property (nonatomic) NSUInteger realPage;
@property (nonatomic) NSUInteger realTotal;

//- (void)appendPhotos:(NSArray <NSString *>*)photos;
//- (void)insertPhotosInFront:(NSArray <NSString *>*)photos;

@end
