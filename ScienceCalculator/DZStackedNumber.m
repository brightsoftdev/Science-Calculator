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
    return [self initWithDouble:d
                     Expression:[[DZNumberFormatter sharedFormatter]
                                 formatDouble:d]
                    andOperator:kOperator_nil];
}

- (id)initWithDouble:(double)d 
          Expression:(NSString *)str 
         andOperator:(int)op
{
    self = [super init];
    if (nil != self) {
        self.rootOperator = op;
        self.expression = str;
        self.value = d;
    }
    return self;
}

@end
