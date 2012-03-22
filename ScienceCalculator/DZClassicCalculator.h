//
//  DZClassicCalculator.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-17.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZNumberFormatter.h"

extern const int kOperator_nil;
extern const int kOperator_add;
extern const int kOperator_sub;
extern const int kOperator_mul;
extern const int kOperator_div;
extern const int kOperator_power;
extern const int kOperator_root;
extern const int kOperator_nCr;
extern const int kOperator_nPr;

@interface DZClassicCalculator : NSObject
{
    NSInteger _maxNumberLength;
    NSInteger _maxPowerNumberLength;
}

@property (readonly) NSInteger maxNumberLength;
@property (readonly) NSInteger maxPowerNumberLength;
@property (nonatomic,retain) DZNumberFormatter * numberFormatter;

+ (DZClassicCalculator *)sharedCalculator;

- (id)initWithMaxNumberLength:(NSInteger)maxNumberLen
         maxPowerNumberLength:(NSInteger)maxPowerNumberlen;

- (NSString *)displayNumber;

- (void)pressDigit:(NSInteger)digit;
- (void)pressNeg;
- (void)pressPoint;
- (void)pressTimesTenPowerX;
- (void)pressDelete;
- (void)longPressDelete;
- (void)pressEqu;
- (void)pressOperator:(NSInteger)op;


@end
