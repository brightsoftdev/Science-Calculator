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

extern const int kFunction_reciprocal;
extern const int kFunction_sqr;
extern const int kFunction_sqrt;
extern const int kFunction_cube;
extern const int kFunction_cuberoot;
extern const int kFunction_factorial;
extern const int kFunction_sin;
extern const int kFunction_cos;
extern const int kFunction_tan;
extern const int kFunction_sind;
extern const int kFunction_cosd;
extern const int kFunction_tand;
extern const int kFunction_sinh;
extern const int kFunction_cosh;
extern const int kFunction_tanh;
extern const int kFunction_asin;
extern const int kFunction_acos;
extern const int kFunction_atan;
extern const int kFunction_asind;
extern const int kFunction_acosd;
extern const int kFunction_atand;
extern const int kFunction_asinh;
extern const int kFunction_acosh;
extern const int kFunction_atanh;
extern const int kFunction_log2;
extern const int kFunction_log10;
extern const int kFunction_ln;
extern const int kFunction_pow2;
extern const int kFunction_pow10;
extern const int kFunction_exp;
extern const int kFunction_neg;

extern const int kMemOp_add;
extern const int kMemOp_sub;
extern const int kMemOp_clear;
extern const int kMemOp_read;

extern const int kConst_pi;
extern const int kConst_e;
extern const int kConst_rand;

@interface DZClassicCalculator : NSObject
{
    NSInteger _maxNumberLength;
    NSInteger _maxPowerNumberLength;
    double _memory;
}

@property (readonly) NSInteger maxNumberLength;
@property (readonly) NSInteger maxPowerNumberLength;
@property (readonly) BOOL isMemoryNoneZero;
@property (nonatomic,retain) DZNumberFormatter * numberFormatter;

+ (DZClassicCalculator *)sharedCalculator;

- (id)initWithMaxNumberLength:(NSInteger)maxNumberLen
         maxPowerNumberLength:(NSInteger)maxPowerNumberlen;

- (NSString *)displayNumber;
- (NSString *)displayExpression;

- (void)pressDigit:(NSInteger)digit;
- (void)pressNeg;
- (void)pressPoint;
- (void)pressTimesTenPowerX;
- (void)pressDelete;
- (void)longPressDelete;
- (void)pressEqu;
- (void)pressOperator:(NSInteger)op;
- (void)pressLeftPar;
- (void)pressRightPar;
- (void)pressFunction:(NSInteger)func;
- (void)pressClear;
- (void)pressMemOp:(NSInteger)op;
- (void)pressConst:(NSInteger)type;

@end
