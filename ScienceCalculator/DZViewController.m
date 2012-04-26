//
//  DZViewController.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-2-26.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZViewController.h"
#import "DZImagePool.h"
#import "DZClassicCalculator.h"

#define SetBtnTitleAndTag(idx,title,tag) \
    [[self.allButtons objectAtIndex:idx]setTag:tag]; \
    [[self.allButtons objectAtIndex:idx]setTitle:title \
    forState:UIControlStateNormal]
#define SetBtnTag(idx,tag) \
    [[self.allButtons objectAtIndex:idx]setTag:tag]
#define SetBtnTitle(idx,title) \
    [[self.allButtons objectAtIndex:idx]setTitle:title \
    forState:UIControlStateNormal]

#pragma mark -
#pragma mark Private extention

@interface DZViewController ()

@property (nonatomic,retain) DZClassicCalculator * calculator;
@property (nonatomic,retain) NSMutableArray * allButtons;
@property (nonatomic,retain) DZImagePool * imagePool;
@property (nonatomic,retain) UIView * btnView1;
@property (nonatomic,retain) UIView * btnView2;
@property (nonatomic,assign) BOOL isDegreeMode;
@property (nonatomic,assign) BOOL isInversed;
@property (nonatomic,assign) BOOL isHold;
@property (nonatomic,assign) BOOL isFn;
@property (nonatomic,retain) UILabel * exprLabel;
@property (nonatomic,retain) UILabel * numLabel;
@property (nonatomic,retain) UILabel * statusLabel;

- (void)buildUpView;
- (void)addButtonAt:(NSInteger)index
                 to:(UIView *)parentView
           position:(NSInteger)row :(NSInteger)column
                   :(NSInteger)width :(NSInteger)height
              title:(NSString *)text
             ofFont:(NSString *)name :(NSInteger)size 
                   :(UIColor *)color
                tag:(NSInteger)tag
             target:(id)target :(SEL)action;
- (void)addButton:(NSInteger)viewIdx
                 :(NSInteger)idx
                 :(NSString *)text
                 :(NSInteger)tag
                 :(SEL)action;

- (void)onFnBtn:(id)sender;
- (void)onFn2Btn:(id)sender;
- (void)onInvBtn:(id)sender;
- (void)onRadBtn:(id)sender;
- (void)onDigitBtn:(id)sender;
- (void)onDot:(id)sender;
- (void)onEE:(id)sender;
- (void)onNeg:(id)sender;
- (void)onDelete:(id)sender;
- (void)onCE:(id)sender;
- (void)onLeftPar:(id)sender;
- (void)onRightPar:(id)sender;
- (void)onClear:(id)sender;
- (void)onOperator:(id)sender;
- (void)onEqu:(id)sender;
- (void)onFunction:(id)sender;
- (void)onHold:(id)sender;
- (void)onMemOp:(id)sender;
- (void)onConst:(id)sender;

- (void)updateDisplay;

@end

#pragma mark - 
#pragma mark Implementation start here

@implementation DZViewController

@synthesize allButtons;
@synthesize imagePool;
@synthesize calculator;
@synthesize btnView1,btnView2;
@synthesize isDegreeMode,isInversed,isHold,isFn;
@synthesize exprLabel,numLabel,statusLabel;

#pragma mark -
#pragma mark button press actions

- (void)onFnBtn:(id)sender
{
    [UIView transitionFromView:self.btnView1
                        toView:self.btnView2
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:NULL];
    self.isFn = YES;
    [self updateDisplay];
}

- (void)onFn2Btn:(id)sender
{
    [UIView transitionFromView:self.btnView2
                        toView:self.btnView1
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:NULL];
    self.isFn = NO;
    [self updateDisplay];
}

- (void)onInvBtn:(id)sender
{
    if (!(self.isInversed)) {
        self.isInversed = YES;
        SetBtnTitleAndTag(45, @"exp", kFunction_exp);
        SetBtnTitleAndTag(46, @"10ⁿ", kFunction_pow10);
        SetBtnTitleAndTag(47, @"2ⁿ", kFunction_pow2);
        SetBtnTitleAndTag(40, @"sinh⁻¹", kFunction_asinh);
        SetBtnTitleAndTag(41, @"cosh⁻¹", kFunction_acosh);
        SetBtnTitleAndTag(42, @"tanh⁻¹", kFunction_atanh);
        SetBtnTitleAndTag(35, @"sin⁻¹", isDegreeMode?kFunction_asind:kFunction_asin);
        SetBtnTitleAndTag(36, @"cos⁻¹", isDegreeMode?kFunction_acosd:kFunction_acos);
        SetBtnTitleAndTag(37, @"tan⁻¹", isDegreeMode?kFunction_atand:kFunction_atan);
    } else {
        self.isInversed = NO;
        SetBtnTitleAndTag(45, @"ln", kFunction_ln);
        SetBtnTitleAndTag(46, @"log₁₀", kFunction_log10);
        SetBtnTitleAndTag(47, @"log₂", kFunction_log2);
        SetBtnTitleAndTag(40, @"sinh", kFunction_sinh);
        SetBtnTitleAndTag(41, @"cosh", kFunction_cosh);
        SetBtnTitleAndTag(42, @"tanh", kFunction_tanh);
        SetBtnTitleAndTag(35, @"sin", isDegreeMode?kFunction_sind:kFunction_sin);
        SetBtnTitleAndTag(36, @"cos", isDegreeMode?kFunction_cosd:kFunction_cos);
        SetBtnTitleAndTag(37, @"tan", isDegreeMode?kFunction_tand:kFunction_tan);
    }
}

- (void)onRadBtn:(id)sender
{
    if (self.isDegreeMode) {
        self.isDegreeMode = NO;
        SetBtnTag(35, isInversed?kFunction_asin:kFunction_sin);
        SetBtnTag(36, isInversed?kFunction_acos:kFunction_cos);
        SetBtnTag(37, isInversed?kFunction_atan:kFunction_tan);
        SetBtnTitle(31, @"Rad");
    } else {
        self.isDegreeMode = YES;
        SetBtnTag(35, isInversed?kFunction_asind:kFunction_sind);
        SetBtnTag(36, isInversed?kFunction_acosd:kFunction_cosd);
        SetBtnTag(37, isInversed?kFunction_atand:kFunction_tand);
        SetBtnTitle(31, @"Deg");
    }
    [self updateDisplay];
}

- (void)onDigitBtn:(id)sender
{
    UIButton * btn = sender;
    [self.calculator pressDigit:btn.tag];
    [self updateDisplay];
}

- (void)onDot:(id)sender
{
    [self.calculator pressPoint];
    [self updateDisplay];
}

- (void)onEE:(id)sender
{
    [self.calculator pressTimesTenPowerX];
    [self updateDisplay];
}

- (void)onNeg:(id)sender
{
    [self.calculator pressNeg];
    [self updateDisplay];
}

- (void)onDelete:(id)sender
{
    [self.calculator pressDelete];
    [self updateDisplay];
}

- (void)onCE:(id)sender
{
    [self.calculator longPressDelete];
    [self updateDisplay];
}

- (void)onLeftPar:(id)sender
{
    [self.calculator pressLeftPar];
    [self updateDisplay];
}

- (void)onRightPar:(id)sender
{
    [self.calculator pressRightPar];
    [self updateDisplay];
}

- (void)onClear:(id)sender
{
    [self.calculator pressClear];
    [self updateDisplay];
}

- (void)onOperator:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [self.calculator pressOperator:btn.tag];
    [self updateDisplay];
    if (self.isFn && !(self.isHold)) {
        [self onFn2Btn:nil];
    }
}

- (void)onEqu:(id)sender
{
    [self.calculator pressEqu];
    [self updateDisplay];
}

- (void)onFunction:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [self.calculator pressFunction:btn.tag];
    [self updateDisplay];
    if (self.isFn && !(self.isHold)) {
        [self onFn2Btn:nil];
    }
}

- (void)onHold:(id)sender
{
    self.isHold = !(self.isHold);
    [self updateDisplay];
}

- (void)onMemOp:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [self.calculator pressMemOp:btn.tag];
    [self updateDisplay];
}

- (void)onConst:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [self.calculator pressConst:btn.tag];
    [self updateDisplay];
    if (self.isFn && !(self.isHold)) {
        [self onFn2Btn:nil];
    }
}

- (void)menuButtonPressed:(id)sender
{
    TTNavigator * navigator = [TTNavigator navigator];
    TTURLAction * action = [[TTURLAction actionWithURLPath:@"tt://menu"]applyAnimated:YES];
    [navigator openURLAction:action];
}
                 
#pragma mark -
#pragma mark Utilities

- (void)updateDisplay
{
    self.numLabel.text = self.calculator.displayNumber;
    self.exprLabel.text = self.calculator.displayExpression;
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                             self.isDegreeMode?@"Deg":@"Rad",
                             self.isHold?@"Hold":@"",
                             self.isFn?@"Fn":@"",
                             self.calculator.isMemoryNoneZero?@"M":@""];
}

#pragma mark -
#pragma mark add buttons and build views

- (void)buildUpView
{
    self.imagePool = [DZImagePool new];
    self.allButtons = [NSMutableArray array];
    self.btnView1 = [[UIView alloc]
                     initWithFrame:CGRectMake(0, 124, 320, 336)];
    self.btnView1.backgroundColor = [UIColor blackColor];
    [self addButton:1:0:@"Fn":0:@selector(onFnBtn:)];
    [self addButton:1:1:@"M+":kMemOp_add:@selector(onMemOp:)];
    [self addButton:1:2:@"M−":kMemOp_sub:@selector(onMemOp:)];
    [self addButton:1:3:@"MR":kMemOp_read:@selector(onMemOp:)];
    [self addButton:1:4:@"MC":kMemOp_clear:@selector(onMemOp:)];
    [self addButton:1:5:@"(":0:@selector(onLeftPar:)];
    [self addButton:1:6:@")":0:@selector(onRightPar:)];
    [self addButton:1:7:@"C":0:@selector(onClear:)];
    [self addButton:1:8:@"CE":0:@selector(onCE:)];
    [self addButton:1:9:@"⌫":0:@selector(onDelete:)];
    [self addButton:1:10:@"÷":kOperator_div:@selector(onOperator:)];
    [self addButton:1:11:@"7":7:@selector(onDigitBtn:)];
    [self addButton:1:12:@"8":8:@selector(onDigitBtn:)];
    [self addButton:1:13:@"9":9:@selector(onDigitBtn:)];
    [self addButton:1:14:@"×10ⁿ":1:@selector(onEE:)];
    [self addButton:1:15:@"×":kOperator_mul:@selector(onOperator:)];
    [self addButton:1:16:@"4":4:@selector(onDigitBtn:)];
    [self addButton:1:17:@"5":5:@selector(onDigitBtn:)];
    [self addButton:1:18:@"6":6:@selector(onDigitBtn:)];
    [self addButton:1:19:@"±":0:@selector(onNeg:)];
    [self addButton:1:20:@"−":kOperator_sub:@selector(onOperator:)];
    [self addButton:1:21:@"1":1:@selector(onDigitBtn:)];
    [self addButton:1:22:@"2":2:@selector(onDigitBtn:)];
    [self addButton:1:23:@"3":3:@selector(onDigitBtn:)];
    [self addButton:1:24:@"F-E":0:@selector(menuButtonPressed:)];
    [self addButton:1:25:@"+":kOperator_add:@selector(onOperator:)];
    [self addButton:1:26:@"0":0:@selector(onDigitBtn:)];
    [self addButton:1:27:@".":1:@selector(onDot:)];
    [self addButton:1:28:@"ans":1:@selector(menuButtonPressed:)];
    [self addButton:1:29:@"=":0:@selector(onEqu:)];
    self.btnView2 = [[UIView alloc]
                     initWithFrame:CGRectMake(0, 124, 320, 336)];
    self.btnView2.backgroundColor = [UIColor blackColor];
    [self addButton:2:30:@"Fn":0:@selector(onFn2Btn:)];
    [self addButton:2:31:@"Rad":0:@selector(onRadBtn:)];
    [self addButton:2:32:@"Inv":0:@selector(onInvBtn:)];
    [self addButton:2:33:@"x⁻¹":kFunction_reciprocal:@selector(onFunction:)];
    [self addButton:2:34:@"Hold":0:@selector(onHold:)];
    [self addButton:2:35:@"sin":kFunction_sin:@selector(onFunction:)];
    [self addButton:2:36:@"cos":kFunction_cos:@selector(onFunction:)];
    [self addButton:2:37:@"tan":kFunction_tan:@selector(onFunction:)];
    [self addButton:2:38:@"x²":kFunction_sqr:@selector(onFunction:)];
    [self addButton:2:39:@"x³":kFunction_cube:@selector(onFunction:)];
    [self addButton:2:40:@"sinh":kFunction_sinh:@selector(onFunction:)];
    [self addButton:2:41:@"cosh":kFunction_cosh:@selector(onFunction:)];
    [self addButton:2:42:@"tanh":kFunction_tanh:@selector(onFunction:)];
    [self addButton:2:43:@"√":kFunction_sqrt:@selector(onFunction:)];
    [self addButton:2:44:@"∛":kFunction_cuberoot:@selector(onFunction:)];
    [self addButton:2:45:@"ln":kFunction_ln:@selector(onFunction:)];
    [self addButton:2:46:@"log₁₀":kFunction_log10:@selector(onFunction:)];
    [self addButton:2:47:@"log₂":kFunction_log2:@selector(onFunction:)];
    [self addButton:2:48:@"xʸ":kOperator_power:@selector(onOperator:)];
    [self addButton:2:49:@"ʸ√x":kOperator_root:@selector(onOperator:)];
    [self addButton:2:50:@"n!":kFunction_factorial:@selector(onFunction:)];
    [self addButton:2:51:@"nCr":kOperator_nCr:@selector(onOperator:)];
    [self addButton:2:52:@"nPr":kOperator_nPr:@selector(onOperator:)];
    [self addButton:2:53:@"π":kConst_pi:@selector(onConst:)];
    [self addButton:2:54:@"e":kConst_e:@selector(onConst:)];
    [self addButton:2:55:@"Rand":kConst_rand:@selector(onConst:)];
    [self addButton:2:56:@"Menu":0:@selector(menuButtonPressed:)];
    [self.view addSubview:self.btnView2];
    [self.view addSubview:self.btnView1];
    exprLabel = [[UILabel alloc]initWithFrame:
                 CGRectMake(5, 5, 310, 30)];
    exprLabel.font = [UIFont fontWithName:@"GillSans" size:24];
    exprLabel.minimumFontSize = 14;
    exprLabel.adjustsFontSizeToFitWidth = YES;
    exprLabel.textAlignment = UITextAlignmentRight;
    exprLabel.lineBreakMode = UILineBreakModeHeadTruncation;
    exprLabel.textColor = [UIColor whiteColor];
    exprLabel.backgroundColor = [UIColor clearColor];
    numLabel = [[UILabel alloc]initWithFrame:
                CGRectMake(5, 25, 310, 90)];
    numLabel.font = [UIFont fontWithName:@"GillSans" size:40];
    numLabel.adjustsFontSizeToFitWidth = YES;
    numLabel.textAlignment = UITextAlignmentRight;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.backgroundColor = [UIColor clearColor];
    statusLabel = [[UILabel alloc]initWithFrame:
                   CGRectMake(5, 106, 310, 14)];
    statusLabel.font = [UIFont fontWithName:@"GillSans" size:14];
    statusLabel.adjustsFontSizeToFitWidth = YES;
    statusLabel.textAlignment = UITextAlignmentLeft;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:exprLabel];
    [self.view addSubview:numLabel];
    [self.view addSubview:statusLabel];
    [self updateDisplay];
}

- (void)addButtonAt:(NSInteger)index
                 to:(UIView *)parentView
           position:(NSInteger)row :(NSInteger)column
                   :(NSInteger)width :(NSInteger)height
              title:(NSString *)text
             ofFont:(NSString *)name :(NSInteger)size 
                   :(UIColor *)color
                tag:(NSInteger)tag
             target:(id)target :(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:tag];
    [btn setBackgroundImage:
     [self.imagePool imageAtIndex:kImage_button]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:
     [self.imagePool imageAtIndex:kImage_buttonPressed]
                   forState:UIControlStateHighlighted];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 9, 9);
    btn.titleLabel.font = [UIFont fontWithName:name 
                                          size:size];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btn addTarget:target action:action
  forControlEvents:UIControlEventTouchUpInside];
    [self.allButtons insertObject:btn atIndex:index];
    [parentView addSubview:btn];
    [btn setFrame:CGRectMake(64*column-64,56*row-56,
                             64*width,56*height)];
}

- (void)addButton:(NSInteger)viewIdx 
                 :(NSInteger)idx 
                 :(NSString *)text 
                 :(NSInteger)tag 
                 :(SEL)action
{
    [self addButtonAt:idx
                   to:(viewIdx==1)?(self.btnView1):(self.btnView2)
             position:(idx%30)/5+1 :(idx%30)%5+1 :1 :1
                title:text
               ofFont:@"GillSans" :32 :[UIColor whiteColor]
                  tag:tag 
               target:self :action];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.calculator = [DZClassicCalculator sharedCalculator];
    self.isInversed = NO;
    self.isDegreeMode = NO;
    self.isHold = NO;
    self.isFn = NO;
    [self buildUpView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation
    || UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.navigationController != nil) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.navigationController != nil) {
        self.navigationController.navigationBarHidden = NO;
    }
}

@end
