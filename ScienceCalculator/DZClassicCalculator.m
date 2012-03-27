//
//  DZClassicCalculator.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-17.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZClassicCalculator.h"
#import "DZStackedNumber.h"
#import "DZMath.h"

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
const int kStatus_error = -1;

const int kOperator_nil = 0;
const int kOperator_add = 1;
const int kOperator_sub = 2;
const int kOperator_mul = 3;
const int kOperator_div = 4;
const int kOperator_power = 5;
const int kOperator_root = 6;
const int kOperator_nCr = 7;
const int kOperator_nPr = 8;
const int kOperator_leftPar = 9;

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
@property (nonatomic,assign) NSInteger unmatchedLeftPars;

- (void)pushCurrentOperator;
- (void)setStatusToAnswer:(double)answer;
- (BOOL)doStackTopOperation;
- (void)startNewExpression;
- (void)clearDisplayNumber;
- (void)matchOneLeftPar;

/// Utilities
- (double)doOperation:(int)op 
          leftOperand:(double)left
         rightOperand:(double)right;
- (int)levelOfOperator:(int)op;
- (NSString *)stringFromOperator:(int)op;

@end

@implementation DZClassicCalculator

#pragma mark -
#pragma mark Properties

@synthesize number,powerNumber,isNegNumber,isNegPowerNumber;
@synthesize numberStack,opStack,currentOperator;
@synthesize status;
@synthesize numberFormatter;
@synthesize answer;
@synthesize unmatchedLeftPars;

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
        [self clearDisplayNumber];
		self.answer = 0;
        self.currentOperator = kOperator_nil;
        self.unmatchedLeftPars = 0;
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
    if (self.status == kStatus_answer
        || self.status == kStatus_error) {
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
            // If no current operator is set, start new expression.
            if (self.currentOperator == kOperator_nil)
                [self startNewExpression];
            [self clearDisplayNumber];
            self.currentOperator = kOperator_nil;
            if (digit == 0) {
                self.status = kStatus_init;
                self.number = @"0";
                break; // break ONLY when 0 pressed.
            }
            // NO break HERE, run THROUGH.
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
            // If no current operator is set, start new expression.
            if (self.currentOperator == kOperator_nil)
                [self startNewExpression];
            [self clearDisplayNumber];
            self.currentOperator = kOperator_nil;
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
            if (kOperator_nil == self.currentOperator) 
                [self startNewExpression];
        case kStatus_fraction:
        case kStatus_integer:
        case kStatus_scientific:
            self.status = kStatus_init;
            [self clearDisplayNumber];
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
    while (self.status != kStatus_error &&
           self.unmatchedLeftPars > 0) {
        [self pressRightPar];
    }
    self.unmatchedLeftPars = 1;
    [self pressRightPar];
    self.unmatchedLeftPars = 0;
}

- (void)pressOperator:(NSInteger)op
{
    switch (self.status) {
        case kStatus_init:
        case kStatus_integer:
        case kStatus_fraction:
        case kStatus_scientific:
            [self setStatusToAnswer:self.displayNumber.doubleValue];
            if (self.status != kStatus_error) {
                [self.numberStack addObject:
                 [[DZStackedNumber alloc]
                  initWithDouble:self.answer]];
                currentOperator = op;
                [self pushCurrentOperator];
            }
            break;
        case kStatus_answer:
            if (self.currentOperator == kOperator_leftPar) {
                break;
            }
            if (self.currentOperator != kOperator_nil
                && [self.opStack count] > 0) {
                [self.opStack removeLastObject];
            }
            self.currentOperator = op;
            [self pushCurrentOperator];
            break;
    }
}

- (void)pressLeftPar
{
    switch (self.status) {
        case kStatus_init:
        case kStatus_answer:
            if (self.status == kStatus_answer &&
                self.currentOperator == kOperator_nil) {
                [self startNewExpression];
            }
            [self.opStack addObject:[NSNumber numberWithInt:kOperator_leftPar]];
            self.currentOperator = kOperator_leftPar;
            self.unmatchedLeftPars = self.unmatchedLeftPars + 1;
            break;
    }
}

- (void)pressRightPar
{
    if (self.unmatchedLeftPars < 1) 
        return;
    switch (self.status) {
        case kStatus_answer:
            if (self.currentOperator == kOperator_nil)
                break;
        case kStatus_fraction:
        case kStatus_init:
        case kStatus_integer:
        case kStatus_scientific:
            [self setStatusToAnswer:self.displayNumber.doubleValue];
            if (self.status == kStatus_error)
                return;
            [self.numberStack addObject:
             [[DZStackedNumber alloc]
              initWithDouble:self.answer]];
            break;
        default:
            return;
    }
    [self matchOneLeftPar];
    self.currentOperator = kOperator_nil;
}

#pragma mark -
#pragma mark Private Interface Implementations

- (void)matchOneLeftPar
{
    while (self.opStack.count > 0) {
        int topOp = [self.opStack.lastObject intValue];
        if (topOp == kOperator_leftPar) {
            [self.opStack removeLastObject];
            self.unmatchedLeftPars = self.unmatchedLeftPars - 1;
            return;
        }
        if ([self doStackTopOperation] == NO) {
            return;
        }
    }
}

- (void)pushCurrentOperator
{
    int curOp = self.currentOperator;
    if (curOp == kOperator_nil) 
        return;
    while (self.opStack.count > 0 
           && self.numberStack.count >= 2
           && kStatus_error != self.status) {
        int topOp = [self.opStack.lastObject intValue];
        if ([self levelOfOperator:topOp] 
            >= [self levelOfOperator:curOp]) {
            if ([self doStackTopOperation] == NO)
                break;
        } else {
            break;
        }
    }
    [self.opStack addObject:[NSNumber numberWithInt:curOp]];
}

- (BOOL)doStackTopOperation
{
    if (self.opStack.count < 1)
        return NO;
    if (self.numberStack.count < 2)
        return NO;
    int topOp = [[self.opStack lastObject]intValue];
    if (topOp == kOperator_nil || topOp == kOperator_leftPar)
        return NO;
    [self.opStack removeLastObject];
    DZStackedNumber * right = [self.numberStack lastObject];
    [self.numberStack removeLastObject];
    DZStackedNumber * left = [self.numberStack lastObject];
    [self.numberStack removeLastObject];
    double resultDouble = [self doOperation:topOp
                                leftOperand:left.value
                               rightOperand:right.value];
    BOOL leftParNeeded =
        [self levelOfOperator:left.rootOperator] <
        [self levelOfOperator:topOp];
    BOOL rightParNeeded = 
        [self levelOfOperator:topOp] >=
        [self levelOfOperator:right.rootOperator];
    NSString * resultExpr = [NSString stringWithFormat:
                             @"%@%@%@ %@ %@%@%@",
                             leftParNeeded?@"(":@"",
                             left.expression,
                             leftParNeeded?@")":@"",
                             [self stringFromOperator:topOp],
                             rightParNeeded?@"(":@"",
                             right.expression,
                             rightParNeeded?@")":@""];
    [self.numberStack addObject:
     [[DZStackedNumber alloc]initWithDouble:resultDouble
                                 Expression:resultExpr
                                andOperator:topOp]];
    [self setStatusToAnswer:resultDouble];
    if (self.status != kStatus_error)
        return YES;
    return NO;
}

- (void)setStatusToAnswer:(double)theAnswer
{
    self.answer = theAnswer;
    if (isfinite(self.answer)) {
        self.status = kStatus_answer;
    } else {
        self.status = kStatus_error;
    }
}

- (void)clearDisplayNumber
{
    //self.answer = 0;
    self.number = @"0";
    self.powerNumber = @"";
    self.isNegNumber = NO;
    self.isNegPowerNumber = NO;
}

- (void)startNewExpression
{
    [self.numberStack removeAllObjects];
    [self.opStack removeAllObjects];
    self.currentOperator = kOperator_nil;
    self.unmatchedLeftPars = 0;
}

#pragma mark -
#pragma mark Utilities

- (int)levelOfOperator:(int)op
{
    switch (op) {
        case kOperator_add: 
        case kOperator_sub:
            return 1;
        case kOperator_mul:
        case kOperator_div:
            return 2;
        case kOperator_power:
        case kOperator_root:
            return 3;
        case kOperator_nCr:
        case kOperator_nPr:
            return 4;
        case kOperator_nil:
            return 5;
        default:
            return 0;
    }
}

- (double)doOperation:(int)op 
          leftOperand:(double)left
         rightOperand:(double)right
{
    switch (op) {
        case kOperator_add:
            return left + right;
        case kOperator_sub:
            return left - right;
        case kOperator_mul:
            return left * right;
        case kOperator_div:
            return left / right;
        case kOperator_power:
            return pow(left, right);
        case kOperator_root:
            return pow(left, 1/right);
        case kOperator_nCr:
            return [DZMath combination:right outOf:left];
        case kOperator_nPr:
            return [DZMath permutation:right outOf:left];
        default:
            return left;
    }
}

- (NSString *)stringFromOperator:(int)op
{
    switch (op) {
        case kOperator_add:
            return @"+";
        case kOperator_sub:
            return @"-";
        case kOperator_mul:
            return @"*";
        case kOperator_div:
            return @"/";
        case kOperator_power:
            return @"^";
        case kOperator_root:
            return @"root";
        case kOperator_nCr:
            return @"C";
        case kOperator_nPr:
            return @"P";
        default:
            return @"nop";
    }
}

@end
