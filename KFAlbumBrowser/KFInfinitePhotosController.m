//
//  KFInfinitePhotosController.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/21/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFInfinitePhotosController.h"

@interface KFInfinitePhotosController ()

@property (nonatomic,assign) NSUInteger curIndex;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageCtrl;

@end

@implementation KFInfinitePhotosController


- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
    [self showStartImage];
}

- (void)initViews{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    flowLayout.minimumLineSpacing = 16;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-8, 0, self.view.bounds.size.width + 16, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
//    [collectionView registerClass:[KFPhotoCell class]
//       forCellWithReuseIdentifier:collectionCellIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIPageControl *pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 20)];
//    pageCtrl.numberOfPages = self.photos.count;
//    pageCtrl.currentPage = self.startIndex;
    pageCtrl.hidesForSinglePage = YES;
    [self.view addSubview:pageCtrl];
    self.pageCtrl = pageCtrl;
}

- (void)showStartImage{

}

@end
