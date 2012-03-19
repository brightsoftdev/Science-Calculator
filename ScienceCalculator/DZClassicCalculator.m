//
//  DZClassicCalculator.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-17.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZClassicCalculator.h"

const int kMaxNumberLength = 14;
const int kMaxPowerNumberLength = 3;
const int kStatus_init = 0;
const int kStatus_integer = 1;
const int kStatus_fraction = 2;
const int kStatus_scientific = 3;

@interface DZClassicCalculator ()
@property (nonatomic,copy) NSString * number;
@property (nonatomic,copy) NSString * powerNumber;
@property (nonatomic,assign) BOOL isNegNumber;
@property (nonatomic,assign) BOOL isNegPowerNumber;
@property (nonatomic,retain) NSMutableArray * numberStack;
@property (nonatomic,retain) NSMutableArray * opStack;
@property (nonatomic,retain) NSMutableArray * exprStack;
@property (nonatomic,assign) NSInteger status;
@end

@implementation DZClassicCalculator

@synthesize number,powerNumber,isNegNumber,isNegPowerNumber;
@synthesize numberStack,opStack,exprStack;
@synthesize status;

static DZClassicCalculator * _sharedCalculator;

+ (DZClassicCalculator *)sharedCalculator
{
    if (_sharedCalculator == nil) {
        _sharedCalculator = [[self alloc]init];
    }
    return _sharedCalculator;
}

- (id)init
{
    self = [super init];
    if (nil != self) {
        self.number = @"0";
        self.powerNumber = @"";
        self.isNegNumber = NO;
        self.isNegPowerNumber = NO;
        self.numberStack = [NSMutableArray arrayWithCapacity:32];
        self.opStack = [NSMutableArray arrayWithCapacity:32];
        self.exprStack = [NSMutableArray arrayWithCapacity:32];
        self.status = kStatus_init;
    }
    return self;
}

- (NSString *)displayNumber
{
    BOOL hasPowerNumber = self.powerNumber.length > 0;
    return [NSString stringWithFormat:@"%@%@%@%@%@",
            (self.isNegNumber)?(@"-"):(@""),
            self.number,
            (hasPowerNumber)?(@"E"):(@""),
            (hasPowerNumber && self.isNegPowerNumber)?(@"-"):(@""),
            self.powerNumber];
}

- (void)pressDigit:(NSInteger)digit
{
    switch (self.status) {
        case kStatus_init:
            if (digit != 0) {
                self.status = kStatus_integer;
                self.number = [NSString stringWithFormat:@"%d", digit];
            }
            break;
        case kStatus_integer:
            if (kMaxNumberLength > [self.number length]) {
                self.number = [NSString stringWithFormat:@"%@%d", self.number, digit];
            }
            break;
        case kStatus_fraction:
            if (kMaxNumberLength > [self.number length]-1) {
                self.number = [NSString stringWithFormat:@"%@%d", self.number, digit];
            }
            break;
        case kStatus_scientific:
            if ([self.powerNumber isEqualToString:@"0"]) {
                self.powerNumber = [NSString stringWithFormat:@"%d", digit];
            } else if (kMaxPowerNumberLength > [self.powerNumber length]) {
                self.powerNumber = [NSString stringWithFormat:@"%@%d", self.powerNumber, digit];
            }
            break;
    }
}

- (void)pressNeg
{
    switch (self.status) {
        case kStatus_init:
        case kStatus_integer:
        case kStatus_fraction:
            self.isNegNumber = !(self.isNegNumber);
            break;
        case kStatus_scientific:
            self.isNegPowerNumber = !(self.isNegPowerNumber);
            break;
    }
}

- (void)pressPoint
{
    switch (self.status) {
        case kStatus_init:
        case kStatus_integer:
            self.status = kStatus_fraction;
            self.number = [self.number stringByAppendingString:@"."];
            break;
    }
}

- (void)pressTimesTenPowerX
{
    switch (self.status) {
        case kStatus_init:
        case kStatus_integer:    
        case kStatus_fraction:
            self.status = kStatus_scientific;
            self.powerNumber = @"0";
            break;
    }
}

@end
