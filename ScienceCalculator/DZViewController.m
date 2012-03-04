//
//  DZViewController.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-2-26.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZViewController.h"
#import "DZImagePool.h"

#define kButton_shift 0
#define kButton_hyp 1
#define kButton_deg 2
#define kButton_xpowery 3
#define kButton_xreciprocal 4
#define kButton_delete 5
#define kButton_nCr 6
#define kButton_log2 7
#define kButton_log10 8
#define kButton_ln 9
#define kButton_xsquareroot 10
#define kButton_xsquare 11
#define kButton_nfactorial 12
#define kButton_sin 13
#define kButton_cos 14
#define kButton_tan 15
#define kButton_leftpar 16
#define kButton_rightpar 17
#define kButton_pi 18
#define kButton_7 19
#define kButton_8 20
#define kButton_9 21
#define kButton_neg 22
#define kButton_C 23
#define kButton_MR 24
#define kButton_4 25
#define kButton_5 26
#define kButton_6 27
#define kButton_add 28
#define kButton_sub 29
#define kButton_Madd 30
#define kButton_1 31
#define kButton_2 32
#define kButton_3 33
#define kButton_mul 34
#define kButton_div 35
#define kButton_Msub 36
#define kButton_timestenpowerx 37
#define kButton_0 38
#define kButton_point 39
#define kButton_equ 40

#define ADDBUTTON(index,name,image) \
    [self addButtonAtIndex:index \
    withImageIndex:image \
    backgroundIndex:kImage_button50x42 \
    backgroundIndexPressed:kImage_button50x42pressed]
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
  backgroundIndexPressed:(NSInteger)pressedImage;

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
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:index];
    [btn setBackgroundImage:[self.imagePool imageAtIndex:bkImage]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[self.imagePool imageAtIndex:pressedImage]
                   forState:UIControlStateHighlighted];
    [btn setImage:[self.imagePool imageAtIndex:image]
             forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonPressed:)
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
    ADDBUTTON(0,@"shift",kImage_shift);
    ADDBUTTON(1,@"hyp",kImage_hyp);
    ADDBUTTON(2,@"deg",kImage_deg);
    ADDBUTTON(3,@"xpowery",kImage_xpowery);
    ADDBUTTON(4,@"xreciprocal",kImage_xreciprocal);
    ADDBUTTON(5,@"delete",kImage_delete);
    ADDBUTTON(6,@"nCr",kImage_nCr);
    ADDBUTTON(7,@"log2",kImage_log2);
    ADDBUTTON(8,@"log10",kImage_log10);
    ADDBUTTON(9,@"ln",kImage_ln);
    ADDBUTTON(10,@"xsquareroot",kImage_xsquareroot);
    ADDBUTTON(11,@"xsquare",kImage_xsquare);
    ADDBUTTON(12,@"nfactorial",kImage_nfactorial);
    ADDBUTTON(13,@"sin",kImage_sin);
    ADDBUTTON(14,@"cos",kImage_cos);
    ADDBUTTON(15,@"tan",kImage_tan);
    ADDBUTTON(16,@"leftpar",kImage_leftpar);
    ADDBUTTON(17,@"rightpar",kImage_rightpar);
    ADDBUTTON(18,@"pi",kImage_pi);
    ADDBUTTON(19,@"7",kImage_7);
    ADDBUTTON(20,@"8",kImage_8);
    ADDBUTTON(21,@"9",kImage_9);
    ADDBUTTON(22,@"neg",kImage_neg);
    ADDBUTTON(23,@"C",kImage_C);
    ADDBUTTON(24,@"MR",kImage_MR);
    ADDBUTTON(25,@"4",kImage_4);
    ADDBUTTON(26,@"5",kImage_5);
    ADDBUTTON(27,@"6",kImage_6);
    ADDBUTTON(28,@"add",kImage_add);
    ADDBUTTON(29,@"sub",kImage_sub);
    ADDBUTTON(30,@"Madd",kImage_Madd);
    ADDBUTTON(31,@"1",kImage_1);
    ADDBUTTON(32,@"2",kImage_2);
    ADDBUTTON(33,@"3",kImage_3);
    ADDBUTTON(34,@"mul",kImage_mul);
    ADDBUTTON(35,@"div",kImage_div);
    ADDBUTTON(36,@"Msub",kImage_Msub);
    ADDBUTTON(37,@"timestenpowerx",kImage_timestenpowerx);
    ADDBUTTON(38,@"0",kImage_0);
    ADDBUTTON(39,@"point",kImage_point);
    ADDBUTTON2(40,@"equ",kImage_equ);
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

@end
