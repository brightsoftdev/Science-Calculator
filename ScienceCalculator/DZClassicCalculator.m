//
//  DZClassicCalculator.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-17.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZClassicCalculator.h"

@interface DZClassicCalculator ()
@property (nonatomic,retain) NSMutableArray * numberStack;
@property (nonatomic,retain) NSMutableArray * opStack;
@property (nonatomic,retain) NSMutableArray * exprStack;
@end

@implementation DZClassicCalculator

@synthesize displayNumber,displayExpression;
@synthesize numberStack,opStack,exprStack;

- (id)init
{
    self = [super init];
    if (nil != self) {
        self.displayNumber = @"";
        self.displayExpression = @"";
        self.numberStack = [NSMutableArray arrayWithCapacity:32];
        self.opStack = [NSMutableArray arrayWithCapacity:32];
        self.exprStack = [NSMutableArray arrayWithCapacity:32];
    }
    return self;
}

@end
