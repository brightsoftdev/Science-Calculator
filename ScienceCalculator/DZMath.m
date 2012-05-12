//
//  DZMath.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-26.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZMath.h"

@implementation DZMath

+ (double)permutation:(double)k outOf:(double)n
{
    if (floor(k)!=k || floor(n)!=n || k > n || k < 0 || n < 0) {
        return NAN;
    }
    double result = 1;
    for (int i = 0; i < k; i++) {
        result *= n - i;
    }
    return result;
}

+ (double)combination:(double)k outOf:(double)n
{
    if (floor(k)!=k || floor(n)!=n || k > n || k < 0 || n < 0) {
        return NAN;
    }
    double result = 1;
    for (int i = 0; i < k; i++) {
        result *= n - i;
        result /= i + 1;
    }
    return result;
}

@end
