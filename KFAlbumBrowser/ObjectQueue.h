//
//  ObjectQueue.h
//  KFAlbumBrowserDemo
//
//  Created by KittyFeng on 4/14/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectQueue : NSObject



@property (nonatomic) NSMutableArray *objects;
@property (nonatomic) NSUInteger front;
@property (nonatomic) NSUInteger rear;

- (instancetype)initWithObjects:(NSArray *)objects andMaxNum:(NSUInteger)maxNum;

- (id)getFrontObject;

- (id)inQueue:(id)object;
- (void)outQueue;


@end
