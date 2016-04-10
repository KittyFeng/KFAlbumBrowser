//
//  ViewController.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/8/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "ViewController.h"
#define imageUrl @"http://123.57.33.218/ayr_odeum/file/music/picture/97dcbd99b380484fb14dedcc132566cf.jpg"
#import "UIImageView+WebCache.h"
#import "KFAlbumBrowser.h"
#import "KFPhoto.h"


@interface ViewController ()
@property (nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:self.imageView];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImage)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:gesture];
}


- (void)openImage{
    KFAlbumBrowser *album = [[KFAlbumBrowser alloc]init];
    KFPhoto *photo = [[KFPhoto alloc]init];
    photo.largeImage = _imageView.image;
    photo.originalFrame = self.imageView.frame;
    album.photos = @[photo];
    [self presentViewController:album animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
