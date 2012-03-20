//
//  DZNumberFormatter.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-20.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZNumberFormatter.h"

@implementation DZNumberFormatter

static DZNumberFormatter * _sharedFormatter;

+ (DZNumberFormatter *)sharedFormatter {
    if (_sharedFormatter == nil) {
        _sharedFormatter = [[self alloc]init];
    }
    return _sharedFormatter;
}

- (id)init {
    return [self initWithMaxNumberLength:14
                    maxPowerNumberLength:3];
}

- (id)initWithMaxNumberLength:(NSInteger)maxNumberLen  
         maxPowerNumberLength:(NSInteger)maxPowerNumberlen
{
    self = [super init];
    if (nil != self) {
        _maxNumberLength = maxNumberLen;
        _maxPowerNumberLength = maxPowerNumberlen;
    }
    return self;
}

- (NSString *)formatDouble:(double)number
{
    return nil;
}

@end
