//
//  DZImagePool.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-4.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZImagePool.h"

#define POOLIMAGE(index,name,filename) \
    [self.pool insertObject: \
    [UIImage imageNamed:filename] \
    atIndex:index]
    
@implementation DZImagePool

@synthesize pool;

- (id)init {
    self = [super init];
    if (nil != self) {
        [self setPool:[NSMutableArray array]];
        POOLIMAGE(0,@"0",@"0.png");
        POOLIMAGE(1,@"1",@"1.png");
        POOLIMAGE(2,@"10powerx",@"10powerx.png");
        POOLIMAGE(3,@"2",@"2.png");
        POOLIMAGE(4,@"2powerx",@"2powerx.png");
        POOLIMAGE(5,@"3",@"3.png");
        POOLIMAGE(6,@"4",@"4.png");
        POOLIMAGE(7,@"5",@"5.png");
        POOLIMAGE(8,@"6",@"6.png");
        POOLIMAGE(9,@"7",@"7.png");
        POOLIMAGE(10,@"8",@"8.png");
        POOLIMAGE(11,@"9",@"9.png");
        POOLIMAGE(12,@"C",@"C.png");
        POOLIMAGE(13,@"MC",@"MC.png");
        POOLIMAGE(14,@"MR",@"MR.png");
        POOLIMAGE(15,@"Madd",@"Madd.png");
        POOLIMAGE(16,@"Msub",@"Msub.png");
        POOLIMAGE(17,@"add",@"add.png");
        POOLIMAGE(18,@"arccos",@"arccos.png");
        POOLIMAGE(19,@"arccosh",@"arccosh.png");
        POOLIMAGE(20,@"arcsin",@"arcsin.png");
        POOLIMAGE(21,@"arcsinh",@"arcsinh.png");
        POOLIMAGE(22,@"arctan",@"arctan.png");
        POOLIMAGE(23,@"arctanh",@"arctanh.png");
        POOLIMAGE(24,@"button102x42",@"button102x42.png");
        POOLIMAGE(25,@"button102x42pressed",@"button102x42pressed.png");
        POOLIMAGE(26,@"button50x42",@"button50x42.png");
        POOLIMAGE(27,@"button50x42pressed",@"button50x42pressed.png");
        POOLIMAGE(28,@"cos",@"cos.png");
        POOLIMAGE(29,@"cosh",@"cosh.png");
        POOLIMAGE(30,@"deg",@"deg.png");
        POOLIMAGE(31,@"delete",@"delete.png");
        POOLIMAGE(32,@"div",@"div.png");
        POOLIMAGE(33,@"e",@"e.png");
        POOLIMAGE(34,@"equ",@"equ.png");
        POOLIMAGE(35,@"exp",@"exp.png");
        POOLIMAGE(36,@"hyp",@"hyp.png");
        POOLIMAGE(37,@"leftpar",@"leftpar.png");
        POOLIMAGE(38,@"ln",@"ln.png");
        POOLIMAGE(39,@"log10",@"log10.png");
        POOLIMAGE(40,@"log2",@"log2.png");
        POOLIMAGE(41,@"mul",@"mul.png");
        POOLIMAGE(42,@"nCr",@"nCr.png");
        POOLIMAGE(43,@"nPr",@"nPr.png");
        POOLIMAGE(44,@"neg",@"neg.png");
        POOLIMAGE(45,@"nfactorial",@"nfactorial.png");
        POOLIMAGE(46,@"pi",@"pi.png");
        POOLIMAGE(47,@"point",@"point.png");
        POOLIMAGE(48,@"rightpar",@"rightpar.png");
        POOLIMAGE(49,@"shift",@"shift.png");
        POOLIMAGE(50,@"sin",@"sin.png");
        POOLIMAGE(51,@"sinh",@"sinh.png");
        POOLIMAGE(52,@"sub",@"sub.png");
        POOLIMAGE(53,@"tan",@"tan.png");
        POOLIMAGE(54,@"tanh",@"tanh.png");
        POOLIMAGE(55,@"timestenpowerx",@"timestenpowerx.png");
        POOLIMAGE(56,@"xpowery",@"xpowery.png");
        POOLIMAGE(57,@"xreciprocal",@"xreciprocal.png");
        POOLIMAGE(58,@"xrooty",@"xrooty.png");
        POOLIMAGE(59,@"xsquare",@"xsquare.png");
        POOLIMAGE(60,@"xsquareroot",@"xsquareroot.png");
    }
    return self;
}

- (void)dealloc {
    [self setPool:nil];
}

- (UIImage *)imageAtIndex:(NSInteger)index {
    return [self.pool objectAtIndex:index];
}

@end
