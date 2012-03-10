//
//  DZViewController.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-2-26.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const int kButton_shift;
extern const int kButton_hyp;
extern const int kButton_deg;
extern const int kButton_xpowery;
extern const int kButton_xreciprocal;
extern const int kButton_delete;
extern const int kButton_nCr;
extern const int kButton_log2;
extern const int kButton_log10;
extern const int kButton_ln;
extern const int kButton_xsquareroot;
extern const int kButton_xsquare;
extern const int kButton_nfactorial;
extern const int kButton_sin;
extern const int kButton_cos;
extern const int kButton_tan;
extern const int kButton_leftpar;
extern const int kButton_rightpar;
extern const int kButton_pi;
extern const int kButton_7;
extern const int kButton_8;
extern const int kButton_9;
extern const int kButton_neg;
extern const int kButton_C;
extern const int kButton_MR;
extern const int kButton_4;
extern const int kButton_5;
extern const int kButton_6;
extern const int kButton_add;
extern const int kButton_sub;
extern const int kButton_Madd;
extern const int kButton_1;
extern const int kButton_2;
extern const int kButton_3;
extern const int kButton_mul;
extern const int kButton_div;
extern const int kButton_Msub;
extern const int kButton_timestenpowerx;
extern const int kButton_0;
extern const int kButton_point;
extern const int kButton_equ;

@interface DZViewController : UIViewController 

@property (nonatomic,retain) IBOutlet UIImageView * screenImgView;
@property (nonatomic,retain) IBOutlet UIImageView * ledDegRad;
@property (nonatomic,retain) IBOutlet UIImageView * ledNormSci;
@property (nonatomic,retain) IBOutlet UIImageView * ledM;
@property (nonatomic,retain) IBOutlet UIButton * menu;

- (IBAction)menuButtonPressed:(id)sender;

@end
