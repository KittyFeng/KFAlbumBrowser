//
//  KFPhotoCell.h
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/15/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFPhotoViewer.h"

@protocol  KFPhotoCellDelegate <NSObject>

@optional
- (void)tapImage:(KFPhoto *)photo inPhotoViewer:(KFPhotoViewer *)photoViewer;

@end


@interface KFPhotoCell : UICollectionViewCell

@property (nonatomic,strong) KFPhotoViewer *photoViewer;
@property (nonatomic,weak) id <KFPhotoCellDelegate> delegate;
- (void)setPhoto:(KFPhoto *)photo startShow:(BOOL)isStarting;
@end
