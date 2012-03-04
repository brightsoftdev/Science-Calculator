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
        POOLIMAGE(13,@"LEDdeg",@"LEDdeg.png");
        POOLIMAGE(14,@"LEDm",@"LEDm.png");
        POOLIMAGE(15,@"LEDnorm",@"LEDnorm.png");
        POOLIMAGE(16,@"LEDrad",@"LEDrad.png");
        POOLIMAGE(17,@"LEDsci",@"LEDsci.png");
        POOLIMAGE(18,@"MC",@"MC.png");
        POOLIMAGE(19,@"MR",@"MR.png");
        POOLIMAGE(20,@"Madd",@"Madd.png");
        POOLIMAGE(21,@"Msub",@"Msub.png");
        POOLIMAGE(22,@"add",@"add.png");
        POOLIMAGE(23,@"arccos",@"arccos.png");
        POOLIMAGE(24,@"arccosh",@"arccosh.png");
        POOLIMAGE(25,@"arcsin",@"arcsin.png");
        POOLIMAGE(26,@"arcsinh",@"arcsinh.png");
        POOLIMAGE(27,@"arctan",@"arctan.png");
        POOLIMAGE(28,@"arctanh",@"arctanh.png");
        POOLIMAGE(29,@"button102x42",@"button102x42.png");
        POOLIMAGE(30,@"button102x42pressed",@"button102x42pressed.png");
        POOLIMAGE(31,@"button50x42",@"button50x42.png");
        POOLIMAGE(32,@"button50x42pressed",@"button50x42pressed.png");
        POOLIMAGE(33,@"cos",@"cos.png");
        POOLIMAGE(34,@"cosh",@"cosh.png");
        POOLIMAGE(35,@"deg",@"deg.png");
        POOLIMAGE(36,@"delete",@"delete.png");
        POOLIMAGE(37,@"div",@"div.png");
        POOLIMAGE(38,@"e",@"e.png");
        POOLIMAGE(39,@"equ",@"equ.png");
        POOLIMAGE(40,@"exp",@"exp.png");
        POOLIMAGE(41,@"hyp",@"hyp.png");
        POOLIMAGE(42,@"leftpar",@"leftpar.png");
        POOLIMAGE(43,@"ln",@"ln.png");
        POOLIMAGE(44,@"log10",@"log10.png");
        POOLIMAGE(45,@"log2",@"log2.png");
        POOLIMAGE(46,@"menu",@"menu.png");
        POOLIMAGE(47,@"mul",@"mul.png");
        POOLIMAGE(48,@"nCr",@"nCr.png");
        POOLIMAGE(49,@"nPr",@"nPr.png");
        POOLIMAGE(50,@"neg",@"neg.png");
        POOLIMAGE(51,@"nfactorial",@"nfactorial.png");
        POOLIMAGE(52,@"pi",@"pi.png");
        POOLIMAGE(53,@"point",@"point.png");
        POOLIMAGE(54,@"rightpar",@"rightpar.png");
        POOLIMAGE(55,@"shift",@"shift.png");
        POOLIMAGE(56,@"sin",@"sin.png");
        POOLIMAGE(57,@"sinh",@"sinh.png");
        POOLIMAGE(58,@"sub",@"sub.png");
        POOLIMAGE(59,@"tan",@"tan.png");
        POOLIMAGE(60,@"tanh",@"tanh.png");
        POOLIMAGE(61,@"timestenpowerx",@"timestenpowerx.png");
        POOLIMAGE(62,@"xpowery",@"xpowery.png");
        POOLIMAGE(63,@"xreciprocal",@"xreciprocal.png");
        POOLIMAGE(64,@"xrooty",@"xrooty.png");
        POOLIMAGE(65,@"xsquare",@"xsquare.png");
        POOLIMAGE(66,@"xsquareroot",@"xsquareroot.png");
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
