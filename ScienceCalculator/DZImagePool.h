//
//  DZImagePool.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-4.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kImage_0 0
#define kImage_1 1
#define kImage_10powerx 2
#define kImage_2 3
#define kImage_2powerx 4
#define kImage_3 5
#define kImage_4 6
#define kImage_5 7
#define kImage_6 8
#define kImage_7 9
#define kImage_8 10
#define kImage_9 11
#define kImage_C 12
#define kImage_MC 13
#define kImage_MR 14
#define kImage_Madd 15
#define kImage_Msub 16
#define kImage_add 17
#define kImage_arccos 18
#define kImage_arccosh 19
#define kImage_arcsin 20
#define kImage_arcsinh 21
#define kImage_arctan 22
#define kImage_arctanh 23
#define kImage_button102x42 24
#define kImage_button102x42pressed 25
#define kImage_button50x42 26
#define kImage_button50x42pressed 27
#define kImage_cos 28
#define kImage_cosh 29
#define kImage_deg 30
#define kImage_delete 31
#define kImage_div 32
#define kImage_e 33
#define kImage_equ 34
#define kImage_exp 35
#define kImage_hyp 36
#define kImage_leftpar 37
#define kImage_ln 38
#define kImage_log10 39
#define kImage_log2 40
#define kImage_mul 41
#define kImage_nCr 42
#define kImage_nPr 43
#define kImage_neg 44
#define kImage_nfactorial 45
#define kImage_pi 46
#define kImage_point 47
#define kImage_rightpar 48
#define kImage_shift 49
#define kImage_sin 50
#define kImage_sinh 51
#define kImage_sub 52
#define kImage_tan 53
#define kImage_tanh 54
#define kImage_timestenpowerx 55
#define kImage_xpowery 56
#define kImage_xreciprocal 57
#define kImage_xrooty 58
#define kImage_xsquare 59
#define kImage_xsquareroot 60

@interface DZImagePool : NSObject

@property (nonatomic,retain) NSMutableArray * pool;

- (UIImage *)imageAtIndex:(NSInteger)index;

@end
