//
//  DZNumberFormatter.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-20.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZNumberFormatter : NSObject
{
    NSInteger _maxNumberLength;
    NSInteger _maxPowerNumberLength;
}

@property (nonatomic,assign) BOOL forceScientific;

+ (DZNumberFormatter *)sharedFormatter;

- (id)initWithMaxNumberLength:(NSInteger)maxNumberLen
         maxPowerNumberLength:(NSInteger)maxPowerNumberlen;

- (NSString *)formatDouble:(double)number;

@end
