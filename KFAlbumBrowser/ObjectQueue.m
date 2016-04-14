//
//  ObjectQueue.m
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/14/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "ObjectQueue.h"

@interface ObjectQueue ()

@property (nonatomic,assign) NSUInteger maxNum;

@end


@implementation ObjectQueue


- (instancetype)initWithObjects:(NSArray *)objects andMaxNum:(NSUInteger)maxNum{
    self = [super init];
    if (self) {
        _objects = [NSMutableArray arrayWithArray:objects];
        _maxNum = maxNum;
        _front = 0;
        _rear = objects.count - 1;
    }
    return self;
}

- (id)getFrontObject{
    return nil;
}

- (id)inQueue:(id)object{
    return nil;
}
- (void)outQueue{

}

@end
