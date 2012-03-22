//
//  DZStackedNumber.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-22.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZStackedNumber.h"
#import "DZClassicCalculator.h"
#import "DZNumberFormatter.h"

@implementation DZStackedNumber

@synthesize rootOperator,value,expression;

- (id)init
{
    return [self initWithDouble:0];
}

- (id)initWithDouble:(double)d
{
    self = [super init];
    if (nil != self) {
        self.rootOperator = kOperator_nil;
        self.expression = [[DZNumberFormatter sharedFormatter]
                           formatDouble:d];
        self.value = d;
    }
    return self;
}

@end
