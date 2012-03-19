//
//  DZClassicCalculator.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-17.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZClassicCalculator : NSObject

+ (DZClassicCalculator *)sharedCalculator;

- (NSString *)displayNumber;

- (void)pressDigit:(NSInteger)digit;
- (void)pressNeg;
- (void)pressPoint;
- (void)pressTimesTenPowerX;


@end
