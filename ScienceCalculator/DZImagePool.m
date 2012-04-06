//
//  DZImagePool.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-4.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZImagePool.h"

const int kImage_button = 0;
const int kImage_buttonPressed = 1;

#define POOLIMAGE(index,name,filename) \
    [self.pool insertObject: \
    [UIImage imageNamed:filename] \
    atIndex:index]
    
@implementation DZImagePool

@synthesize pool;

- (id)init {
    self = [super init];
    if (nil != self) {
        [self setPool:[NSMutableArray array]];
        POOLIMAGE(0,@"button",@"button.png");
        POOLIMAGE(1,@"buttonPressed",@"buttonPressed.png");
    }
    return self;
}

- (void)dealloc {
    [self setPool:nil];
}

- (UIImage *)imageAtIndex:(NSInteger)index {
    return [self.pool objectAtIndex:index];
}

@end
