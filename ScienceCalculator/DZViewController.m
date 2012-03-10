//
//  DZViewController.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-2-26.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZViewController.h"
#import "DZImagePool.h"

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
    andAction:@selector(action)]
#define ADDBUTTON2(index,name,image) \
    [self addButtonAtIndex:index \
    withImageIndex:image \
    backgroundIndex:kImage_button102x42 \
    backgroundIndexPressed:kImage_button102x42pressed]
#define MOVEBUTTON(index,x,y,width,height) \
    [self moveButtonAtIndex:index \
    toFrameRect:CGRectMake(x,y,width,height)]

@interface DZViewController ()

@property (nonatomic,retain) NSMutableArray * allButtons;
@property (nonatomic,retain) DZImagePool * imagePool;

- (void)buttonPressed:(id)sender;

- (void)addButtonAtIndex:(NSInteger)index
          withImageIndex:(NSInteger)image
         backgroundIndex:(NSInteger)bkImage
  backgroundIndexPressed:(NSInteger)pressedImage
               andAction:(SEL)action;

- (void)moveAllButtonsToDeviceOrientationAnimated:(BOOL)animated;

- (void)moveButtonAtIndex:(NSInteger)index
              toFrameRect:(CGRect)rect;

@end

@implementation DZViewController

@synthesize allButtons;
@synthesize screenImgView;
@synthesize imagePool;
@synthesize ledM,ledDegRad,ledNormSci,menu;

- (void)moveButtonAtIndex:(NSInteger)index toFrameRect:(CGRect)rect
{
    UIButton * btn = [self.allButtons objectAtIndex:index];
    [btn setFrame:rect];
}

- (void)buttonPressed:(id)sender
{
    UIButton * btn = sender;
    NSLog(@"btn: %d", btn.tag);
}

- (void)addButtonAtIndex:(NSInteger)index
          withImageIndex:(NSInteger)image
         backgroundIndex:(NSInteger)bkImage
  backgroundIndexPressed:(NSInteger)pressedImage
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
    [btn addTarget:self action:action
  forControlEvents:UIControlEventTouchUpInside];
    [self.allButtons insertObject:btn atIndex:index];
    [self.view addSubview:btn];
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
    }
    if (animated == YES)
        [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imagePool = [DZImagePool new];
    self.allButtons = [NSMutableArray array];
    ADDBUTTON(0,shift,buttonPressed:);
    ADDBUTTON(1,hyp,buttonPressed:);
    ADDBUTTON(2,deg,buttonPressed:);
    ADDBUTTON(3,xpowery,buttonPressed:);
    ADDBUTTON(4,xreciprocal,buttonPressed:);
    ADDBUTTON(5,delete,buttonPressed:);
    ADDBUTTON(6,nCr,buttonPressed:);
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
    ADDBUTTON(19,7,buttonPressed:);
    ADDBUTTON(20,8,buttonPressed:);
    ADDBUTTON(21,9,buttonPressed:);
    ADDBUTTON(22,neg,buttonPressed:);
    ADDBUTTON(23,C,buttonPressed:);
    ADDBUTTON(24,MR,buttonPressed:);
    ADDBUTTON(25,4,buttonPressed:);
    ADDBUTTON(26,5,buttonPressed:);
    ADDBUTTON(27,6,buttonPressed:);
    ADDBUTTON(28,add,buttonPressed:);
    ADDBUTTON(29,sub,buttonPressed:);
    ADDBUTTON(30,Madd,buttonPressed:);
    ADDBUTTON(31,1,buttonPressed:);
    ADDBUTTON(32,2,buttonPressed:);
    ADDBUTTON(33,3,buttonPressed:);
    ADDBUTTON(34,mul,buttonPressed:);
    ADDBUTTON(35,div,buttonPressed:);
    ADDBUTTON(36,Msub,buttonPressed:);
    ADDBUTTON(37,timestenpowerx,buttonPressed:);
    ADDBUTTON(38,0,buttonPressed:);
    ADDBUTTON(39,point,buttonPressed:);
    ADDBUTTON(40,equ,buttonPressed:);
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

- (IBAction)menuButtonPressed:(id)sender
{
    TTNavigator * navigator = [TTNavigator navigator];
    TTURLAction * action = [[TTURLAction actionWithURLPath:@"tt://menu"]applyAnimated:YES];
    [navigator openURLAction:action];
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
