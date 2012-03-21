//
//  DZNumberFormatter.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-20.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZNumberFormatter.h"

@interface DZNumberFormatter ()
@property (nonatomic,retain) NSNumberFormatter * sci;
@property (nonatomic,retain) NSNumberFormatter * dec;
@end

@implementation DZNumberFormatter

@synthesize sci,dec;

static DZNumberFormatter * _sharedFormatter;

+ (DZNumberFormatter *)sharedFormatter {
    if (_sharedFormatter == nil) {
        _sharedFormatter = [[self alloc]init];
    }
    return _sharedFormatter;
}

- (id)init {
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
        self.sci = [[NSNumberFormatter alloc]init];
        self.sci.numberStyle = NSNumberFormatterScientificStyle;
        self.sci.usesGroupingSeparator = NO;
        self.sci.usesSignificantDigits = YES;
        self.sci.maximumSignificantDigits = maxNumberLen;
        self.sci.maximumFractionDigits = maxNumberLen-1;
        self.sci.maximumIntegerDigits = maxNumberLen;
        self.dec = [[NSNumberFormatter alloc]init];
        self.dec.numberStyle = NSNumberFormatterDecimalStyle;
        self.dec.usesGroupingSeparator = NO;
        self.dec.usesSignificantDigits = YES;
        self.dec.maximumSignificantDigits = maxNumberLen;
        self.dec.maximumFractionDigits = maxNumberLen-1;
        self.dec.maximumIntegerDigits = maxNumberLen;
    }
    return self;
}

- (NSString *)formatDouble:(double)number
{
    if (number == 0) {
        return @"0";
    }
    NSNumber * num = [NSNumber numberWithDouble:number];
    if (number+1 < pow(10, _maxNumberLength)
        && number > pow(0.1, _maxNumberLength/2)) {
        return [dec stringFromNumber:num];
    } else {
        return [sci stringFromNumber:num];
    }
}

@end
