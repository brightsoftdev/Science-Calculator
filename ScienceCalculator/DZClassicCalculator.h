//
//  DZClassicCalculator.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-17.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZClassicCalculator : NSObject
{
    NSInteger _maxNumberLength;
    NSInteger _maxPowerNumberLength;
}

@property (readonly) NSInteger maxNumberLength;
@property (readonly) NSInteger maxPowerNumberLength;

+ (DZClassicCalculator *)sharedCalculator;

- (id)initWithMaxNumberLength:(NSInteger)maxNumberLen
         maxPowerNumberLength:(NSInteger)maxPowerNumberlen;

- (NSString *)displayNumber;

- (void)pressDigit:(NSInteger)digit;
- (void)pressNeg;
- (void)pressPoint;
- (void)pressTimesTenPowerX;


@end
