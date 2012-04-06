//
//  DZImagePool.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-4.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int kImage_button;
extern const int kImage_buttonPressed;

@interface DZImagePool : NSObject

@property (nonatomic,retain) NSMutableArray * pool;

- (UIImage *)imageAtIndex:(NSInteger)index;

@end
