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
@property (nonatomic) UIImageView *imageView2;
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
    
    
    
    self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    [self.view addSubview:self.imageView2];
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:@"http://friendq-10009900.image.myqcloud.com/fateship/bc/74/c7ece1d964db164599a59eb7a131/pic/1460515448_8042853.jpg!friendqsmall"]];
    
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImage2)];
    self.imageView2.userInteractionEnabled = YES;
    [self.imageView2 addGestureRecognizer:gesture2];
    
}


- (void)openImage{
    KFAlbumBrowser *album = [[KFAlbumBrowser alloc]init];
    KFPhoto *photo1 = [[KFPhoto alloc]init];
    photo1.largeImage = _imageView.image;
    photo1.originalFrame = [self.view convertRect:self.imageView.frame toView:nil];
    
    
    KFPhoto *photo = [[KFPhoto alloc]init];
    photo.thumbImage = _imageView2.image;
    photo.largeUrl = @"http://friendq-10009900.image.myqcloud.com/fateship/bc/74/c7ece1d964db164599a59eb7a131/pic/1460515448_8042853.jpg";
    photo.originalFrame = [self.view convertRect:self.imageView2.frame toView:nil];
    album.photos = @[photo1,photo];
    photo.contentMode = UIViewContentModeScaleToFill;
    photo1.contentMode = UIViewContentModeScaleToFill;
    
    [self presentViewController:album animated:YES completion:nil];
}


- (void)openImage2{
//    KFAlbumBrowser *album = [[KFAlbumBrowser alloc]init];
    KFPhoto *photo1 = [[KFPhoto alloc]init];
    photo1.largeImage = _imageView.image;
    photo1.contentMode = UIViewContentModeScaleToFill;
    photo1.originalFrame = [self.view convertRect:self.imageView.frame toView:nil];
//    album.photos = @[photo1];
//    [self presentViewController:album animated:YES completion:nil];
    
    
    KFAlbumBrowser *album = [[KFAlbumBrowser alloc]init];
    KFPhoto *photo = [[KFPhoto alloc]init];
    photo.contentMode = UIViewContentModeScaleToFill;
    photo.thumbImage = _imageView2.image;
    photo.largeUrl = @"http://friendq-10009900.image.myqcloud.com/fateship/bc/74/c7ece1d964db164599a59eb7a131/pic/1460515448_8042853.jpg";
    photo.originalFrame = [self.view convertRect:self.imageView2.frame toView:nil];
    album.photos = @[photo1,photo];
    album.startIndex = 1;
    
    [self presentViewController:album animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
