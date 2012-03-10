//
//  DZImagePool.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-4.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int kImage_0;
extern const int kImage_1;
extern const int kImage_10powerx;
extern const int kImage_2;
extern const int kImage_2powerx;
extern const int kImage_3;
extern const int kImage_4;
extern const int kImage_5;
extern const int kImage_6;
extern const int kImage_7;
extern const int kImage_8;
extern const int kImage_9;
extern const int kImage_C;
extern const int kImage_LEDdeg;
extern const int kImage_LEDm;
extern const int kImage_LEDnorm;
extern const int kImage_LEDrad;
extern const int kImage_LEDsci;
extern const int kImage_MC;
extern const int kImage_MR;
extern const int kImage_Madd;
extern const int kImage_Msub;
extern const int kImage_add;
extern const int kImage_arccos;
extern const int kImage_arccosh;
extern const int kImage_arcsin;
extern const int kImage_arcsinh;
extern const int kImage_arctan;
extern const int kImage_arctanh;
extern const int kImage_button102x42;
extern const int kImage_button102x42pressed;
extern const int kImage_button50x42;
extern const int kImage_button50x42pressed;
extern const int kImage_cos;
extern const int kImage_cosh;
extern const int kImage_deg;
extern const int kImage_delete;
extern const int kImage_div;
extern const int kImage_e;
extern const int kImage_equ;
extern const int kImage_exp;
extern const int kImage_hyp;
extern const int kImage_leftpar;
extern const int kImage_ln;
extern const int kImage_log10;
extern const int kImage_log2;
extern const int kImage_menu;
extern const int kImage_mul;
extern const int kImage_nCr;
extern const int kImage_nPr;
extern const int kImage_neg;
extern const int kImage_nfactorial;
extern const int kImage_pi;
extern const int kImage_point;
extern const int kImage_rightpar;
extern const int kImage_shift;
extern const int kImage_sin;
extern const int kImage_sinh;
extern const int kImage_sub;
extern const int kImage_tan;
extern const int kImage_tanh;
extern const int kImage_timestenpowerx;
extern const int kImage_xpowery;
extern const int kImage_xreciprocal;
extern const int kImage_xrooty;
extern const int kImage_xsquare;
extern const int kImage_xsquareroot;

@interface DZImagePool : NSObject

@property (nonatomic,retain) NSMutableArray * pool;

- (UIImage *)imageAtIndex:(NSInteger)index;

@end
