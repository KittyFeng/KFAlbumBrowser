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
#import "KFPhoto.h"
#import "KFPhotosController.h"

@interface ViewController ()

@property (nonatomic) NSArray <NSString *> *smallURLArr;
@property (nonatomic) NSArray <NSString *> *largeURLArr;
@property (nonatomic) NSMutableArray <UIImageView *>*imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.smallURLArr = @[@"http://c.hiphotos.baidu.com/ting/pic/item/b03533fa828ba61ec79abd0b4334970a304e5999.jpg",@"http://c.hiphotos.baidu.com/ting/pic/item/b03533fa828ba61ec79abd0b4334970a304e5999.jpg",@"http://c.hiphotos.baidu.com/ting/pic/item/b03533fa828ba61ec79abd0b4334970a304e5999.jpg",@"http://friendq-10009900.image.myqcloud.com/fateship/bc/74/c7ece1d964db164599a59eb7a131/pic/1460515448_8042853.jpg",@"http://img.qiuyuehui.com/qyh/b9/1/d29/88c/86d/ec7/a77/29f/3db/c9e/a90/e20okb/50037da8-8b8d-4b3f-90b3-0aa29ed378e5.png"];
    self.largeURLArr = @[@"http://a.hiphotos.baidu.com/ting/pic/item/09fa513d269759eecc4015efb0fb43166d22df86.jpg",@"http://a.hiphotos.baidu.com/ting/pic/item/09fa513d269759eecc4015efb0fb43166d22df86.jpg",@"http://a.hiphotos.baidu.com/ting/pic/item/09fa513d269759eecc4015efb0fb43166d22df86.jpg",@"",@""];
    self.imageArray = [NSMutableArray arrayWithCapacity:self.largeURLArr.count];
    for (int i = 0; i<self.largeURLArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100*i, 100, 100)];
        [self.view addSubview:imageView];
        if (!self.smallURLArr[i].length) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_largeURLArr[i]]];
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:_smallURLArr[i]]];
        }
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImage:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesture];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.view addSubview:imageView];
        [self.imageArray addObject:imageView];
    }
    
    
}


- (void)openImage:(UITapGestureRecognizer *)gesture{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSMutableArray *photos  = [NSMutableArray arrayWithCapacity:self.imageArray.count];
    for (int i = 0; i<self.imageArray.count; i++) {
        KFPhoto *photo = [[KFPhoto alloc]init];
        
        photo.thumbView = _imageArray[i];
        photo.largeUrl = self.largeURLArr[i];
        [photos addObject:photo];
    }
    
//    KFPhotosBrowser *album = [[KFPhotosBrowser alloc]init];
//    album.photos = photos;
//    album.startIndex = [self.imageArray indexOfObject:imageView];
//    [self presentViewController:album animated:YES completion:nil];
    
    KFPhotosController *photoCtrl = [[KFPhotosController alloc]init];
    photoCtrl.photos = photos;
    photoCtrl.startIndex = [self.imageArray indexOfObject:imageView];
    [self presentViewController:photoCtrl animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
