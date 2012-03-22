//
//  DZStackedNumber.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-22.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZStackedNumber : NSObject 

@property(nonatomic,copy) NSString * expression;
@property(nonatomic,assign) int rootOperator;
@property(nonatomic,assign) double value;

- (id)initWithDouble:(double)d;

@end
