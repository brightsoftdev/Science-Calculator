//
//  DZClassicCalculator.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-17.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZClassicCalculator.h"
#import "DZStackedNumber.h"

#define LASTCHAR(nsstr) [nsstr characterAtIndex: \
    ([nsstr length]-1)]
#define TRIMRIGHT(nsstr,len) [nsstr substringToIndex: \
    ([nsstr length]-len)]

#pragma mark -
#pragma mark Constant

const int kStatus_init = 0;
const int kStatus_integer = 1;
const int kStatus_fraction = 2;
const int kStatus_scientific = 3;
const int kStatus_answer = 4;

const int kOperator_nil = 0;
const int kOperator_add = 1;
const int kOperator_sub = 2;
const int kOperator_mul = 3;
const int kOperator_div = 4;
const int kOperator_power = 5;
const int kOperator_root = 6;
const int kOperator_nCr = 7;
const int kOperator_nPr = 8;

#pragma mark -
#pragma mark Private Interface

@interface DZClassicCalculator ()
@property (nonatomic,copy) NSString * number;
@property (nonatomic,copy) NSString * powerNumber;
@property (nonatomic,assign) BOOL isNegNumber;
@property (nonatomic,assign) BOOL isNegPowerNumber;
@property (nonatomic,assign) double answer;
@property (nonatomic,retain) NSMutableArray * numberStack;
@property (nonatomic,retain) NSMutableArray * opStack;
@property (nonatomic,assign) NSInteger currentOperator;
@property (nonatomic,assign) NSInteger status;
@end

@implementation DZClassicCalculator

#pragma mark -
#pragma mark Properties

@synthesize number,powerNumber,isNegNumber,isNegPowerNumber;
@synthesize numberStack,opStack,currentOperator;
@synthesize status;
@synthesize numberFormatter;
@synthesize answer;

- (NSInteger)maxNumberLength {
    return _maxNumberLength;
}

- (NSInteger)maxPowerNumberLength {
    return _maxPowerNumberLength;
}

#pragma mark -
#pragma mark Static Member

static DZClassicCalculator * _sharedCalculator;

+ (DZClassicCalculator *)sharedCalculator
{
    if (_sharedCalculator == nil) {
        _sharedCalculator = [[self alloc]init];
    }
    return _sharedCalculator;
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
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
        self.number = @"0";
        self.powerNumber = @"";
        self.isNegNumber = NO;
        self.isNegPowerNumber = NO;
        self.answer = 0;
        self.currentOperator = kOperator_nil;
        self.numberStack = [NSMutableArray arrayWithCapacity:32];
        self.opStack = [NSMutableArray arrayWithCapacity:32];
        self.status = kStatus_init;
        self.numberFormatter = [DZNumberFormatter sharedFormatter];
    }
    return self;
}

#pragma mark -
#pragma mark Public Interface Implementations

- (NSString *)displayNumber
{
    if (self.status == kStatus_answer) {
        return [self.numberFormatter formatDouble:self.answer];
    }
    BOOL hasPowerNumber = self.powerNumber.length > 0;
    return [NSString stringWithFormat:@"%@%@%@%@%@",
            (self.isNegNumber)?(@"-"):(@""),
            self.number,
            (hasPowerNumber)?(@"E"):(@""),
            (hasPowerNumber && self.isNegPowerNumber)?(@"-"):(@""),
            self.powerNumber];
}

#pragma mark -
#pragma mark Button Pressed

- (void)pressDigit:(NSInteger)digit
{
    switch (self.status) {
        case kStatus_answer:
            //TODO: push op to stack?
            if (digit == 0) {
                self.status = kStatus_init;
                self.number = @"0";
                self.isNegNumber = NO;
                self.powerNumber = @"";
                self.isNegPowerNumber = NO;
                break;
            }
        case kStatus_init:
            if (digit != 0) {
                self.status = kStatus_integer;
                self.number = [NSString stringWithFormat:@"%d", digit];
            }
            break;
        case kStatus_integer:
            if (self.maxNumberLength > [self.number length]) {
                self.number = [NSString stringWithFormat:@"%@%d", self.number, digit];
            }
            break;
        case kStatus_fraction:
            if (self.maxNumberLength > [self.number length]-1) {
                self.number = [NSString stringWithFormat:@"%@%d", self.number, digit];
            }
            break;
        case kStatus_scientific:
            if ([self.powerNumber isEqualToString:@"0"]) {
                self.powerNumber = [NSString stringWithFormat:@"%d", digit];
            } else if (self.maxPowerNumberLength > [self.powerNumber length]) {
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
        case kStatus_answer:
            //TODO: push op to stack?
            // NO break HERE, run THROUGH
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

- (void)longPressDelete
{
    switch (self.status) {
        case kStatus_answer:
            self.answer = 0;
        case kStatus_fraction:
        case kStatus_integer:
        case kStatus_scientific:
            self.status = kStatus_init;
            self.powerNumber = @"";
            self.number = @"0";
            self.isNegNumber = NO;
            self.isNegPowerNumber = NO;
            break;
    }
}

- (void)pressDelete
{
    switch (self.status) {
        case kStatus_answer:
            [self longPressDelete];
            break;
        case kStatus_fraction:
            if (LASTCHAR(self.number) == '.') {
                self.number = TRIMRIGHT(self.number, 1);
                if ([self.number isEqualToString:@"0"]) {
                    self.status = kStatus_init;
                    self.isNegNumber = NO;
                } else {
                    self.status = kStatus_integer;
                }
            } else {
                self.number = TRIMRIGHT(self.number, 1);
            }
            break;
        case kStatus_integer:
            if (self.number.length > 1) {
                self.number = TRIMRIGHT(self.number, 1);
            } else {
                self.number = @"0";
                self.isNegNumber = NO;
                self.status = kStatus_init;
            }
            break;
        case kStatus_scientific:
            if (self.powerNumber.length > 1) {
                self.powerNumber = TRIMRIGHT(self.powerNumber, 1);
            } else {
                self.powerNumber = @"";
                self.isNegPowerNumber = NO;
                NSRange range = [self.number rangeOfString:@"."];
                if (range.location == NSNotFound) {
                    if ([self.number isEqualToString:@"0"]) {
                        self.status = kStatus_init;
                        self.isNegNumber = NO;
                    } else {
                        self.status = kStatus_integer;
                    }
                } else {
                    self.status = kStatus_fraction;
                }
            }
            break;
    }
}

- (void)pressEqu
{
    //TODO: These codes are PLACE HOLDER only.
    self.answer = [[self displayNumber]doubleValue];
    self.status = kStatus_answer;
}

- (void)pressOperator:(NSInteger)op
{
    switch (self.status) {
        case kStatus_init:
        case kStatus_integer:
        case kStatus_fraction:
        case kStatus_scientific:
            self.answer = [[self displayNumber]doubleValue];
            [self.numberStack addObject:
             [[DZStackedNumber alloc]initWithDouble:self.answer]];
            currentOperator = op;
            self.status = kStatus_answer;
            break;
        case kStatus_answer:
            self.currentOperator = op;
            break;
    }
}

@end
