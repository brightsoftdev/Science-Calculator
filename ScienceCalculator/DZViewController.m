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

#pragma mark -
#pragma mark kButton consts

const int kButton_shift = 0;
const int kButton_hyp = 1;
const int kButton_deg = 2;
const int kButton_xpowery = 3;
const int kButton_xreciprocal = 4;
const int kButton_delete = 5;
const int kButton_nCr = 6;
const int kButton_log2 = 7;
const int kButton_log10 = 8;
const int kButton_ln = 9;
const int kButton_xsquareroot = 10;
const int kButton_xsquare = 11;
const int kButton_nfactorial = 12;
const int kButton_sin = 13;
const int kButton_cos = 14;
const int kButton_tan = 15;
const int kButton_leftpar = 16;
const int kButton_rightpar = 17;
const int kButton_pi = 18;
const int kButton_7 = 19;
const int kButton_8 = 20;
const int kButton_9 = 21;
const int kButton_neg = 22;
const int kButton_C = 23;
const int kButton_MR = 24;
const int kButton_4 = 25;
const int kButton_5 = 26;
const int kButton_6 = 27;
const int kButton_add = 28;
const int kButton_sub = 29;
const int kButton_Madd = 30;
const int kButton_1 = 31;
const int kButton_2 = 32;
const int kButton_3 = 33;
const int kButton_mul = 34;
const int kButton_div = 35;
const int kButton_Msub = 36;
const int kButton_timestenpowerx = 37;
const int kButton_0 = 38;
const int kButton_point = 39;
const int kButton_equ = 40;

#define ADDBUTTON(index,name,action) \
    [self addButtonAtIndex:index \
    withImageIndex:kImage_##name \
    backgroundIndex:kImage_button50x42 \
    backgroundIndexPressed:kImage_button50x42pressed \
    addTarget:self \
    andAction:@selector(action)]
#define ADDBUTTON2(index,name,action) \
    [self addButtonAtIndex:index \
    withImageIndex:kImage_##name \
    backgroundIndex:kImage_button102x42 \
    backgroundIndexPressed:kImage_button102x42pressed \
    addTarget:self \
    andAction:@selector(action)]
#define MOVEBUTTON(index,x,y,width,height) \
    [self moveButtonAtIndex:index \
    toFrameRect:CGRectMake(x,y,width,height)]
#define SETBUTTONIMAGE(index,image) \
    [[self.allButtons objectAtIndex:index] \
    setImage:[self.imagePool imageAtIndex:image] \
    forState:UIControlStateNormal]

#pragma mark -
#pragma mark Private extention

@interface DZViewController ()

@property (nonatomic,retain) DZClassicCalculator * calculator;
@property (nonatomic,retain) NSMutableArray * allButtons;
@property (nonatomic,retain) DZImagePool * imagePool;
@property (nonatomic,assign) BOOL shiftIsPressed;
@property (nonatomic,assign) BOOL hypIsPressed;
@property (nonatomic,assign) BOOL degIsPressed;
@property (nonatomic,retain) UILongPressGestureRecognizer * longPressRecognizer;

- (void)buttonPressed:(id)sender;
- (void)shiftButtonPressed:(id)sender;
- (void)hypButtonPressed:(id)sender;
- (void)degButtonPressed:(id)sender;
- (void)digitButtonPressed:(id)sender;
- (void)deleteButtonLongPressed:(id)sender;
- (void)operatorButtonPressed:(id)sender;

- (void)addButtonAtIndex:(NSInteger)index
          withImageIndex:(NSInteger)image
         backgroundIndex:(NSInteger)bkImage
  backgroundIndexPressed:(NSInteger)pressedImage
               addTarget:(id)target
               andAction:(SEL)action;

- (void)moveAllButtonsToDeviceOrientationAnimated:(BOOL)animated;

- (void)moveButtonAtIndex:(NSInteger)index
              toFrameRect:(CGRect)rect;

@end

#pragma mark - 
#pragma mark Implementation start here

@implementation DZViewController

@synthesize allButtons;
@synthesize screenImgView;
@synthesize imagePool;
@synthesize ledM,ledDegRad,ledNormSci,menu;
@synthesize shiftIsPressed,hypIsPressed,degIsPressed;
@synthesize numberLabel,exprLabel;
@synthesize calculator;
@synthesize longPressRecognizer;

#pragma mark -
#pragma mark buttonPress actions

- (IBAction)menuButtonPressed:(id)sender
{
    TTNavigator * navigator = [TTNavigator navigator];
    TTURLAction * action = [[TTURLAction actionWithURLPath:@"tt://menu"]applyAnimated:YES];
    [navigator openURLAction:action];
}

- (void)buttonPressed:(id)sender
{
    UIButton * btn = sender;
    switch ([btn tag]) {
        case kButton_point:
            [self.calculator pressPoint];
            self.numberLabel.text = [self.calculator displayNumber];
            break;
        case kButton_neg:
            [self.calculator pressNeg];
            self.numberLabel.text = [self.calculator displayNumber];
            break;
        case kButton_timestenpowerx:
            [self.calculator pressTimesTenPowerX];
            self.numberLabel.text = [self.calculator displayNumber];
            break;
        case kButton_delete:
            [self.calculator pressDelete];
            self.numberLabel.text = [self.calculator displayNumber];
            break;
        case kButton_equ:
            [self.calculator pressEqu];
            self.numberLabel.text = [self.calculator displayNumber];
            break;
        default:
            NSLog(@"btn: %d", btn.tag);
            break;
    }
}

- (void)shiftButtonPressed:(id)sender
{
    if (self.shiftIsPressed) {
        self.shiftIsPressed = NO;
        SETBUTTONIMAGE(kButton_xpowery, kImage_xpowery);
        SETBUTTONIMAGE(kButton_nCr, kImage_nCr);
        SETBUTTONIMAGE(kButton_log2, kImage_log2);
        SETBUTTONIMAGE(kButton_log10, kImage_log10);
        SETBUTTONIMAGE(kButton_ln, kImage_ln);
        SETBUTTONIMAGE(kButton_pi, kImage_pi);
        SETBUTTONIMAGE(kButton_MR, kImage_MR);
        if (self.hypIsPressed) {
            SETBUTTONIMAGE(kButton_sin, kImage_sinh);
            SETBUTTONIMAGE(kButton_cos, kImage_cosh);
            SETBUTTONIMAGE(kButton_tan, kImage_tanh);
        } else {
            SETBUTTONIMAGE(kButton_sin, kImage_sin);
            SETBUTTONIMAGE(kButton_cos, kImage_cos);
            SETBUTTONIMAGE(kButton_tan, kImage_tan);
        }
    } else {
        self.shiftIsPressed = YES;
        SETBUTTONIMAGE(kButton_xpowery, kImage_xrooty);
        SETBUTTONIMAGE(kButton_nCr, kImage_nPr);
        SETBUTTONIMAGE(kButton_log2, kImage_2powerx);
        SETBUTTONIMAGE(kButton_log10, kImage_10powerx);
        SETBUTTONIMAGE(kButton_ln, kImage_exp);
        SETBUTTONIMAGE(kButton_pi, kImage_e);
        SETBUTTONIMAGE(kButton_MR, kImage_MC);
        if (self.hypIsPressed) {
            SETBUTTONIMAGE(kButton_sin, kImage_arcsinh);
            SETBUTTONIMAGE(kButton_cos, kImage_arccosh);
            SETBUTTONIMAGE(kButton_tan, kImage_arctanh);
        } else {
            SETBUTTONIMAGE(kButton_sin, kImage_arcsin);
            SETBUTTONIMAGE(kButton_cos, kImage_arccos);
            SETBUTTONIMAGE(kButton_tan, kImage_arctan);
        }
    }
}

- (void)hypButtonPressed:(id)sender
{
    if (self.hypIsPressed) {
        self.hypIsPressed = NO;
        if (self.shiftIsPressed) {
            SETBUTTONIMAGE(kButton_sin, kImage_arcsin);
            SETBUTTONIMAGE(kButton_cos, kImage_arccos);
            SETBUTTONIMAGE(kButton_tan, kImage_arctan);
        } else {
            SETBUTTONIMAGE(kButton_sin, kImage_sin);
            SETBUTTONIMAGE(kButton_cos, kImage_cos);
            SETBUTTONIMAGE(kButton_tan, kImage_tan);
        }
    } else {
        self.hypIsPressed = YES;
        if (self.shiftIsPressed) {
            SETBUTTONIMAGE(kButton_sin, kImage_arcsinh);
            SETBUTTONIMAGE(kButton_cos, kImage_arccosh);
            SETBUTTONIMAGE(kButton_tan, kImage_arctanh);
        } else {
            SETBUTTONIMAGE(kButton_sin, kImage_sinh);
            SETBUTTONIMAGE(kButton_cos, kImage_cosh);
            SETBUTTONIMAGE(kButton_tan, kImage_tanh);
        }
    }
}

- (void)degButtonPressed:(id)sender
{
    if (self.degIsPressed) {
        self.degIsPressed = NO;
        self.ledDegRad.image = [self.imagePool imageAtIndex:kImage_LEDrad];
    } else {
        self.degIsPressed = YES;
        self.ledDegRad.image = [self.imagePool imageAtIndex:kImage_LEDdeg];
    }
}

- (void)digitButtonPressed:(id)sender
{
    switch ([sender tag]) {
        case kButton_0:
            [self.calculator pressDigit:0];
            break;
        case kButton_1:
            [self.calculator pressDigit:1];
            break;
        case kButton_2:
            [self.calculator pressDigit:2];
            break;
        case kButton_3:
            [self.calculator pressDigit:3];
            break;
        case kButton_4:
            [self.calculator pressDigit:4];
            break;
        case kButton_5:
            [self.calculator pressDigit:5];
            break;
        case kButton_6:
            [self.calculator pressDigit:6];
            break;
        case kButton_7:
            [self.calculator pressDigit:7];
            break;
        case kButton_8:
            [self.calculator pressDigit:8];
            break;
        case kButton_9:
            [self.calculator pressDigit:9];
            break;
    }
    self.numberLabel.text = [self.calculator displayNumber];
}

- (void)deleteButtonLongPressed:(id)sender
{
    UILongPressGestureRecognizer * gr = sender;
    if (gr.state == UIGestureRecognizerStateEnded) {
        [self.calculator longPressDelete];
        self.numberLabel.text = [self.calculator displayNumber];
    }
}

- (void)operatorButtonPressed:(id)sender
{
    switch ([sender tag]) {
        case kButton_add:
            [self.calculator pressOperator:kOperator_add];
            break;
        case kButton_sub:
            [self.calculator pressOperator:kOperator_sub];
            break;
        case kButton_mul:
            [self.calculator pressOperator:kOperator_mul];
            break;
        case kButton_div:
            [self.calculator pressOperator:kOperator_div];
            break;
        case kButton_xpowery:
            [self.calculator pressOperator:
             (self.shiftIsPressed?kOperator_root:kOperator_power)];
            break;
        case kButton_nCr:
            [self.calculator pressOperator:
             (self.shiftIsPressed?kOperator_nPr:kOperator_nCr)];
            break;
    }
}

#pragma mark -
#pragma mark add and move buttons

- (void)addButtonAtIndex:(NSInteger)index
          withImageIndex:(NSInteger)image
         backgroundIndex:(NSInteger)bkImage
  backgroundIndexPressed:(NSInteger)pressedImage
               addTarget:(id)target
               andAction:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:index];
    [btn setBackgroundImage:[self.imagePool imageAtIndex:bkImage]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[self.imagePool imageAtIndex:pressedImage]
                   forState:UIControlStateHighlighted];
    [btn setImage:[self.imagePool imageAtIndex:image]
             forState:UIControlStateNormal];
    [btn addTarget:target action:action
  forControlEvents:UIControlEventTouchUpInside];
    [self.allButtons insertObject:btn atIndex:index];
    [self.view addSubview:btn];
}

- (void)moveButtonAtIndex:(NSInteger)index toFrameRect:(CGRect)rect
{
    UIButton * btn = [self.allButtons objectAtIndex:index];
    [btn setFrame:rect];
}

- (void)moveAllButtonsToDeviceOrientationAnimated:(BOOL)animated
{
    if (animated == YES) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
    }
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait
        || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        for (int r = 0; r < 6; r++)
            for (int c = 0; c < 6; c++)
                MOVEBUTTON(r*6+c, 5+52*c, 138+46*r, 50, 42);
        for (int c = 0; c < 4; c++)
            MOVEBUTTON(36+c, 5+52*c, 414, 50, 42);
        MOVEBUTTON(40, 213, 414, 102, 42);
        self.screenImgView.frame = CGRectMake(5, 26, 310, 108);
        self.menu.frame = CGRectMake(5, 5, 50, 21);
        self.ledDegRad.frame = CGRectMake(57, 5, 50, 21);
        self.ledNormSci.frame = CGRectMake(109, 5, 50, 21);
        self.ledM.frame = CGRectMake(161, 5, 50, 21);
        self.exprLabel.numberOfLines = 3;
        self.exprLabel.frame = CGRectMake(10, 30, 300, 60);
        self.numberLabel.frame = CGRectMake(10, 86, 300, 40);
    } else {
        for (int r = 3; r < 6; r++) 
            for (int c = 0; c < 6; c++) 
                MOVEBUTTON(r*6+c, 162+c*53, r*44-8, 50, 42);
        for (int c = 0; c < 4; c++) 
            MOVEBUTTON(36+c, 162+c*53, 256, 50, 42);
        MOVEBUTTON(40, 374, 256, 103, 42);
        for (int r = 1; r < 3; r++)
            for (int c = 1; c < 4; c++)
                MOVEBUTTON(r*6+c, c*53-50, r*44+80, 50, 42);
        MOVEBUTTON(0, 3, 80, 50, 42);
        MOVEBUTTON(1, 56, 80, 50, 42);
        MOVEBUTTON(2, 109, 80, 50, 42);
        MOVEBUTTON(5, 427, 80, 50, 42);
        MOVEBUTTON(16, 321, 80, 50, 42);
        MOVEBUTTON(17, 374, 80, 50, 42);
        MOVEBUTTON(3, 3, 212, 50, 42);
        MOVEBUTTON(4, 56, 212, 50, 42);
        MOVEBUTTON(11, 109, 212, 50, 42);
        MOVEBUTTON(6, 3, 256, 50, 42);
        MOVEBUTTON(12, 56, 256, 50, 42);
        MOVEBUTTON(10, 109, 256, 50, 42);
        self.screenImgView.frame = CGRectMake(3, 5, 474, 73);
        self.menu.frame = CGRectMake(187, 80, 50, 21);
        self.ledDegRad.frame = CGRectMake(187, 101, 50, 21);
        self.ledNormSci.frame = CGRectMake(240,101, 50, 21);
        self.ledM.frame = CGRectMake(240, 80, 50, 21);
        self.exprLabel.numberOfLines = 2;
        self.exprLabel.frame = CGRectMake(10, 6, 460, 40);
        self.numberLabel.frame = CGRectMake(10, 42, 460, 30);
    }
    if (animated == YES)
        [UIView commitAnimations];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.longPressRecognizer = 
        [[UILongPressGestureRecognizer alloc]
         initWithTarget:self 
         action:@selector(deleteButtonLongPressed:)];
    self.calculator = [DZClassicCalculator sharedCalculator];
    self.numberLabel.text = [calculator displayNumber];
    self.shiftIsPressed = NO;
    self.hypIsPressed = NO;
    self.degIsPressed = YES;
    self.ledM.image = nil;
    self.imagePool = [DZImagePool new];
    self.allButtons = [NSMutableArray array];
    ADDBUTTON(0,shift,shiftButtonPressed:);
    ADDBUTTON(1,hyp,hypButtonPressed:);
    ADDBUTTON(2,deg,degButtonPressed:);
    ADDBUTTON(3,xpowery,operatorButtonPressed:);
    ADDBUTTON(4,xreciprocal,buttonPressed:);
    ADDBUTTON(5,delete,buttonPressed:);
    ADDBUTTON(6,nCr,operatorButtonPressed:);
    ADDBUTTON(7,log2,buttonPressed:);
    ADDBUTTON(8,log10,buttonPressed:);
    ADDBUTTON(9,ln,buttonPressed:);
    ADDBUTTON(10,xsquareroot,buttonPressed:);
    ADDBUTTON(11,xsquare,buttonPressed:);
    ADDBUTTON(12,nfactorial,buttonPressed:);
    ADDBUTTON(13,sin,buttonPressed:);
    ADDBUTTON(14,cos,buttonPressed:);
    ADDBUTTON(15,tan,buttonPressed:);
    ADDBUTTON(16,leftpar,buttonPressed:);
    ADDBUTTON(17,rightpar,buttonPressed:);
    ADDBUTTON(18,pi,buttonPressed:);
    ADDBUTTON(19,7,digitButtonPressed:);
    ADDBUTTON(20,8,digitButtonPressed:);
    ADDBUTTON(21,9,digitButtonPressed:);
    ADDBUTTON(22,neg,buttonPressed:);
    ADDBUTTON(23,C,buttonPressed:);
    ADDBUTTON(24,MR,buttonPressed:);
    ADDBUTTON(25,4,digitButtonPressed:);
    ADDBUTTON(26,5,digitButtonPressed:);
    ADDBUTTON(27,6,digitButtonPressed:);
    ADDBUTTON(28,add,operatorButtonPressed:);
    ADDBUTTON(29,sub,operatorButtonPressed:);
    ADDBUTTON(30,Madd,buttonPressed:);
    ADDBUTTON(31,1,digitButtonPressed:);
    ADDBUTTON(32,2,digitButtonPressed:);
    ADDBUTTON(33,3,digitButtonPressed:);
    ADDBUTTON(34,mul,operatorButtonPressed:);
    ADDBUTTON(35,div,operatorButtonPressed:);
    ADDBUTTON(36,Msub,buttonPressed:);
    ADDBUTTON(37,timestenpowerx,buttonPressed:);
    ADDBUTTON(38,0,digitButtonPressed:);
    ADDBUTTON(39,point,buttonPressed:);
    ADDBUTTON2(40,equ,buttonPressed:);
    [[self.allButtons objectAtIndex:kButton_delete]addGestureRecognizer:self.longPressRecognizer];
    [self moveAllButtonsToDeviceOrientationAnimated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (YES);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self moveAllButtonsToDeviceOrientationAnimated:YES];
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
