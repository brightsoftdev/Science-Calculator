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
const int kOperator_func = 10;

const int kFunction_reciprocal = 0;
const int kFunction_sqr = 1;
const int kFunction_sqrt = 2;
const int kFunction_cube = 3;
const int kFunction_cuberoot = 4;
const int kFunction_factorial = 5;
const int kFunction_sin = 6;
const int kFunction_cos = 7;
const int kFunction_tan = 8;
const int kFunction_sind = 9;
const int kFunction_cosd = 10;
const int kFunction_tand = 11;
const int kFunction_sinh = 12;
const int kFunction_cosh = 13;
const int kFunction_tanh = 14;
const int kFunction_asin = 15;
const int kFunction_acos = 16;
const int kFunction_atan = 17;
const int kFunction_asind = 18;
const int kFunction_acosd = 19;
const int kFunction_atand = 20;
const int kFunction_asinh = 21;
const int kFunction_acosh = 22;
const int kFunction_atanh = 23;
const int kFunction_log2 = 24;
const int kFunction_log10 = 25;
const int kFunction_ln = 26;
const int kFunction_pow2 = 27;
const int kFunction_pow10 = 28;
const int kFunction_exp = 29;
const int kFunction_neg = 30;

const int kMemOp_add = 0;
const int kMemOp_sub = 1;
const int kMemOp_clear = 2;
const int kMemOp_read = 3;

const int kConst_pi = 0;
const int kConst_e = 1;
const int kConst_rand = 2;

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
- (void)setStatusToAnswerAndStackIt:(double)answer;
- (void)setStatusToAnswerAndStackIt:(double)answer withName:(NSString *)name;
- (BOOL)doStackTopOperation;
- (void)startNewExpression;
- (void)clearDisplayNumber;
- (void)matchOneLeftPar;
- (void)parenthesesTopStackedNumber;
- (void)feedInputNumber:(double)num withName:(NSString *)name;

/// Utilities
- (double)doOperation:(int)op 
          leftOperand:(double)left
         rightOperand:(double)right;
- (double)doFunction:(int)func
            argument:(double)arg;
- (int)levelOfOperator:(int)op;
- (NSString *)stringFromOperator:(int)op;
- (NSString *)stringFromFunction:(int)func;

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

- (BOOL)isMemoryNoneZero
{
    return _memory != 0.0;
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
        srand(time(0));
        _maxNumberLength = maxNumberLen;
        _maxPowerNumberLength = maxPowerNumberlen;
        _memory = 0.0;
        _lastAnswer = 0.0;
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

- (NSString *)displayExpression
{
    if (self.opStack.count < 1) {
        if (self.numberStack.count < 1)
            return @"";
        else 
            return [self.numberStack.lastObject expression];
    }
    NSString * rightopr = @"";
    int opTop = self.opStack.count - 1;
    int numTop = self.numberStack.count - 1;
    if (self.status == kStatus_answer && 
        self.currentOperator == kOperator_nil) {
        rightopr = [[self.numberStack objectAtIndex:numTop]expression];
        numTop--;
    }
    for (int i = opTop; i >= 0; i--) {
        int op = [[self.opStack objectAtIndex:i]intValue];
        switch (op) {
            case kOperator_leftPar:
                rightopr = [NSString stringWithFormat:@"(%@", rightopr];
                break;
            default:
                rightopr = [NSString stringWithFormat:@"%@ %@ %@",
                            [[self.numberStack objectAtIndex:numTop]expression],
                            [self stringFromOperator:op],
                            rightopr];
                numTop--;
                break;
        }
    }
    return rightopr;
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
        case kStatus_answer:
            [self pressFunction:kFunction_neg];
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
    if (isfinite(self.answer)) {
        _lastAnswer = self.answer;
    }
}

- (void)pressOperator:(NSInteger)op
{
    switch (self.status) {
        case kStatus_init:
        case kStatus_integer:
        case kStatus_fraction:
        case kStatus_scientific:
            currentOperator = op;
            [self pushCurrentOperator];
            [self setStatusToAnswerAndStackIt:
             self.displayNumber.doubleValue];
            break;
        case kStatus_answer:
            if (self.currentOperator == kOperator_leftPar) {
                break;
            }
            if (self.currentOperator != kOperator_nil
                && [self.opStack count] > 0) {
                [self.opStack removeLastObject];
            }
            if (self.numberStack.count > 0 &&
                [self levelOfOperator:op] >
                [self levelOfOperator:[self.numberStack.lastObject rootOperator]]) {
                [self parenthesesTopStackedNumber];
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
            [self setStatusToAnswerAndStackIt:
             self.displayNumber.doubleValue];
            if (self.status == kStatus_error)
                return;
            break;
        default:
            return;
    }
    [self matchOneLeftPar];
    self.currentOperator = kOperator_nil;
}

- (void)pressFunction:(NSInteger)func
{
    // If arg yet not stacked, stack it first.
    switch (self.status) {
        case kStatus_answer:
            if (self.currentOperator == kOperator_nil)
                break;
            // ELSE run THROUGH
        case kStatus_fraction:
        case kStatus_init:
        case kStatus_integer:
        case kStatus_scientific:
            self.currentOperator = kOperator_nil;
            [self setStatusToAnswerAndStackIt:
             self.displayNumber.doubleValue];
            break;
    }
    if (kStatus_error != self.status &&
        self.numberStack.count > 0) {
        DZStackedNumber * arg = self.numberStack.lastObject;
        arg.value = [self doFunction:func argument:arg.value];
        if (arg.rootOperator == kOperator_nil) {
            NSCharacterSet * set = [NSCharacterSet 
                                    characterSetWithCharactersInString:@"-eE"];
            NSRange range = [arg.expression rangeOfCharacterFromSet:set];
            if (range.location != NSNotFound) {
                arg.rootOperator = kOperator_func;
            }
        }
        arg.expression = [NSString stringWithFormat:@"%@%@%@",
                          (arg.rootOperator != kOperator_nil)?@"(":@" ",
                          arg.expression,
                          (arg.rootOperator != kOperator_nil)?@")":@""];
        arg.expression = [NSString stringWithFormat:[self stringFromFunction:func],
                          arg.expression];
        arg.rootOperator = kOperator_func;
        [self setStatusToAnswer:arg.value];
    }
}

- (void)pressClear
{
    [self startNewExpression];
    [self clearDisplayNumber];
    self.status = kStatus_init;
}

- (void)pressMemOp:(NSInteger)op
{
    if (op == kMemOp_add || op == kMemOp_sub) {
        switch (self.status) {
            case kStatus_init:
            case kStatus_integer:
            case kStatus_fraction:
            case kStatus_scientific:
                self.currentOperator = kOperator_nil;
                [self setStatusToAnswerAndStackIt:
                 self.displayNumber.doubleValue];
                if (self.status == kStatus_error)
                    break;
                // RUN THROUGH
            case kStatus_answer:
                if (op == kMemOp_add) {
                    _memory += self.answer;
                } else {
                    _memory -= self.answer;
                }
                if (!isfinite(_memory)) {
                    self.answer = _memory;
                    self.status = kStatus_error;
                    _memory = 0.0;
                }
                break;
            default:
                break;
        }
        return;
    } else if (op == kMemOp_clear) {
        _memory = 0.0;
        return;
    } else if (op == kMemOp_read) {
        [self feedInputNumber:_memory withName:nil];
        return;
    }
}

- (void)pressConst:(NSInteger)type
{
    double value = 0.0;
    NSString * name = nil;
    switch (type) {
        case kConst_e:
            value = M_E;
            name = @"e";
            break;
        case kConst_pi:
            value = M_PI;
            name = @"pi";
            break;
        case kConst_rand:
            value = (rand() % 10000)/10000.0;
            break;
    }
    [self feedInputNumber:value withName:name];
}

- (void)pressAnswer
{
    [self feedInputNumber:_lastAnswer withName:@"ans"];
}

- (void)pressFtoE
{
    switch (self.status) {
        case kStatus_init:
        case kStatus_integer:
        case kStatus_fraction:
        case kStatus_scientific:
            self.currentOperator = kOperator_nil;
            [self setStatusToAnswerAndStackIt:
             self.displayNumber.doubleValue];
            if (self.status == kStatus_error)
                break;
            // RUN THROUGH
        case kStatus_answer:
            self.numberFormatter.forceScientific = 
            !(self.numberFormatter.forceScientific);
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Private Interface Implementations

- (void)parenthesesTopStackedNumber
{
    [self.numberStack.lastObject setExpression:
     [NSString stringWithFormat:@"(%@)",
      [self.numberStack.lastObject expression]]];
    [self.numberStack.lastObject setRootOperator:
     kOperator_nil];
}

- (void)matchOneLeftPar
{
    while (self.opStack.count > 0) {
        int topOp = [self.opStack.lastObject intValue];
        if (topOp == kOperator_leftPar) {
            [self.opStack removeLastObject];
            self.unmatchedLeftPars = self.unmatchedLeftPars - 1;
            [self parenthesesTopStackedNumber];
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

- (void)setStatusToAnswerAndStackIt:(double)theAnswer
{
    self.answer = theAnswer;
    if (isfinite(self.answer)) {
        self.status = kStatus_answer;
        [self.numberStack addObject:
         [[DZStackedNumber alloc]
          initWithDouble:theAnswer]];
    } else {
        self.status = kStatus_error;
    }
}

- (void)setStatusToAnswerAndStackIt:(double)theAnswer 
                           withName:(NSString *)name
{
    self.answer = theAnswer;
    if (isfinite(self.answer)) {
        self.status = kStatus_answer;
        [self.numberStack addObject:
         [[DZStackedNumber alloc]
          initWithDouble:theAnswer
          Expression:name
          andOperator:kOperator_func]];
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

- (void)feedInputNumber:(double)num
               withName:(NSString *)name
{
    switch (self.status) {
        case kStatus_answer:
            if (self.currentOperator == kOperator_nil) {
                [self startNewExpression];
            }
            // RUN THROUGH
        case kStatus_init:
        case kStatus_integer:
        case kStatus_fraction:
        case kStatus_scientific:
            self.currentOperator = kOperator_nil;
            if (name == nil) {
                [self setStatusToAnswerAndStackIt:num];
            } else {
                [self setStatusToAnswerAndStackIt:num
                                         withName:name];
            }
            break;
        default:
            break;
    }
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
        case kOperator_func:
            return 5;
        case kOperator_nil:
            return 6;
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

- (double)doFunction:(int)func argument:(double)arg
{
    switch (func) {
        case kFunction_reciprocal:
            return 1 / arg;
        case kFunction_sqr:
            return arg * arg;
        case kFunction_sqrt:
            return sqrt(arg);
        case kFunction_cube:
            return pow(arg, 3.0);
        case kFunction_cuberoot:
            return pow(arg, 1.0/3.0);
        case kFunction_factorial:
            return [DZMath permutation:arg outOf:arg];
        case kFunction_sin:
            return sin(arg);
        case kFunction_cos:
            return cos(arg);
        case kFunction_tan:
            return tan(arg);
        case kFunction_sind:
            return sin(arg/180.0*M_PI);
        case kFunction_cosd:
            return cos(arg/180.0*M_PI);
        case kFunction_tand:
            return tan(arg/180.8*M_PI);
        case kFunction_sinh:
            return sinh(arg);
        case kFunction_cosh:
            return cosh(arg);
        case kFunction_tanh:
            return tanh(arg);
        case kFunction_asin:
            return asin(arg);
        case kFunction_acos:
            return acos(arg);
        case kFunction_atan:
            return atan(arg);
        case kFunction_asind:
            return asin(arg)*180.0/M_PI;
        case kFunction_acosd:
            return acos(arg)*180.0/M_PI;
        case kFunction_atand:
            return atan(arg)*180.0/M_PI;
        case kFunction_asinh:
            return asinh(arg);
        case kFunction_acosh:
            return acosh(arg);
        case kFunction_atanh:
            return atanh(arg);
        case kFunction_log2:
            return log2(arg);
        case kFunction_log10:
            return log10(arg);
        case kFunction_ln:
            return log(arg);
        case kFunction_pow2:
            return pow(2.0, arg);
        case kFunction_pow10:
            return pow(10.0, arg);
        case kFunction_exp:
            return exp(arg);
        case kFunction_neg:
            return arg * (-1.0);
        default:
            return 0;
    }
}

- (NSString *)stringFromOperator:(int)op
{
    switch (op) {
        case kOperator_add:
            return @"+";
        case kOperator_sub:
            return @"−";
        case kOperator_mul:
            return @"×";
        case kOperator_div:
            return @"÷";
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

- (NSString *)stringFromFunction:(int)func
{
    switch (func) {
        case kFunction_reciprocal:
            return @"%@⁻¹";
        case kFunction_sqr:
            return @"%@²";
        case kFunction_sqrt:
            return @"√%@";
        case kFunction_cube:
            return @"%@³";
        case kFunction_cuberoot:
            return @"∛%@";
        case kFunction_factorial:
            return @"%@!";
        case kFunction_sin:
            return @"sin%@";
        case kFunction_cos:
            return @"cos%@";
        case kFunction_tan:
            return @"tan%@";
        case kFunction_sind:
            return @"sind%@";
        case kFunction_cosd:
            return @"cosd%@";
        case kFunction_tand:
            return @"tand%@";
        case kFunction_sinh:
            return @"sinh%@";
        case kFunction_cosh:
            return @"cosh%@";
        case kFunction_tanh:
            return @"tanh%@";
        case kFunction_asin:
            return @"sin⁻¹%@";
        case kFunction_acos:
            return @"cos⁻¹%@";
        case kFunction_atan:
            return @"tan⁻¹%@";
        case kFunction_asind:
            return @"sind⁻¹%@";
        case kFunction_acosd:
            return @"cosd⁻¹%@";
        case kFunction_atand:
            return @"tand⁻¹%@";
        case kFunction_asinh:
            return @"sinh⁻¹%@";
        case kFunction_acosh:
            return @"cosh⁻¹%@";
        case kFunction_atanh:
            return @"tanh⁻¹%@";
        case kFunction_log2:
            return @"log₂%@";
        case kFunction_log10:
            return @"log₁₀%@";
        case kFunction_ln:
            return @"ln%@";
        case kFunction_pow2:
            return @"pow₂%@";
        case kFunction_pow10:
            return @"pow₁₀%@";
        case kFunction_exp:
            return @"exp%@";
        case kFunction_neg:
            return @"-%@";
        default:
            return @"%@";
    }
}

@end
