//
//  DZViewController.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-2-26.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZViewController.h"

#define ADDBUTTON(index,name,image) \
    [self addButtonAtIndex:index \
    withText:name \
    orImageNamed:image \
    backgroundImage:bkImg \
    backgroundImagePressed:pressedImg]
#define ADDBUTTON2(index,name,image) \
    [self addButtonAtIndex:index \
    withText:name \
    orImageNamed:image \
    backgroundImage:bkImg2 \
    backgroundImagePressed:pressedImg2]
#define MOVEBUTTON(index,x,y,width,height) \
    [self moveButtonAtIndex:index \
    toFrameRect:CGRectMake(x,y,width,height)]

@interface DZViewController ()

@property (nonatomic,retain) NSMutableArray * allButtons;

- (void)buttonPressed:(id)sender;

- (void)addButtonAtIndex:(NSInteger)index
                withText:(NSString *)title
            orImageNamed:(NSString *)image
         backgroundImage:(UIImage *)bkImage
  backgroundImagePressed:(UIImage *)pressedImage;

- (void)moveAllButtonsToDeviceOrientationAnimated:(BOOL)animated;

- (void)moveButtonAtIndex:(NSInteger)index
              toFrameRect:(CGRect)rect;

@end

@implementation DZViewController

@synthesize allButtons;
@synthesize screenImgView;

- (void)moveButtonAtIndex:(NSInteger)index toFrameRect:(CGRect)rect
{
    UIButton * btn = [self.allButtons objectAtIndex:index];
    [btn setFrame:rect];
}

- (void)buttonPressed:(id)sender
{
    UIButton * btn = sender;
    NSLog(@"btn: %@", [btn titleForState:UIControlStateNormal]);
}

- (void)addButtonAtIndex:(NSInteger)index
                withText:(NSString *)title
            orImageNamed:(NSString *)image
         backgroundImage:(UIImage *)bkImage
  backgroundImagePressed:(UIImage *)pressedImage
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:bkImage
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:pressedImage
                   forState:UIControlStateHighlighted];
    if (image == nil) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    } else
        [btn setImage:[UIImage imageNamed:image]
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
        [self.screenImgView
         setFrame:CGRectMake(5, 5, 310, 129)];
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
        [self.screenImgView
         setFrame:CGRectMake(3, 5, 474, 73)];
    }
    if (animated == YES)
        [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.allButtons = [NSMutableArray array];
    UIImage * bkImg = [UIImage imageNamed:@"button50x42.png"];
    UIImage * pressedImg = [UIImage imageNamed:@"button50x42pressed.png"];
    UIImage * bkImg2 = [UIImage imageNamed:@"button102x42.png"];
    UIImage * pressedImg2 = [UIImage imageNamed:@"button102x42pressed.png"];
    ADDBUTTON(0, @"shift", @"shift.png");
    ADDBUTTON(1, @"hyp", @"hyp.png");
    ADDBUTTON(2, @"deg", @"deg.png");
    ADDBUTTON(3, @"x^y", @"xpowery.png");
    ADDBUTTON(4, @"x^-1", @"xreciprocal.png");
    ADDBUTTON(5, @"<=", @"delete.png");
    ADDBUTTON(6, @"nCr", @"nCr.png");
    ADDBUTTON(7, @"log2", @"log2.png");
    ADDBUTTON(8, @"log10", @"log10.png");
    ADDBUTTON(9, @"ln", @"ln.png");
    ADDBUTTON(10, @"xsquareroot", @"xsquareroot.png");
    ADDBUTTON(11, @"×square", @"xsquare.png");
    ADDBUTTON(12, @"n!", @"nfactorial.png");
    ADDBUTTON(13, @"sin", @"sin.png");
    ADDBUTTON(14, @"cos", @"cos.png");
    ADDBUTTON(15, @"tan", @"tan.png");
    ADDBUTTON(16, @"(", @"leftpar.png");
    ADDBUTTON(17, @")", @"rightpar.png");
    ADDBUTTON(18, @"", @"pi.png");
    ADDBUTTON(19, @"7", @"7.png");
    ADDBUTTON(20, @"8", @"8.png");
    ADDBUTTON(21, @"9", @"9.png");
    ADDBUTTON(22, @"neg", @"neg.png");
    ADDBUTTON(23, @"C", @"C.png");
    ADDBUTTON(24, @"MR", @"MR.png");
    ADDBUTTON(25, @"4", @"4.png");
    ADDBUTTON(26, @"5", @"5.png");
    ADDBUTTON(27, @"6", @"6.png");
    ADDBUTTON(28, @"+", @"add.png");
    ADDBUTTON(29, @"-", @"sub.png");
    ADDBUTTON(30, @"M+", @"Madd.png");
    ADDBUTTON(31, @"1", @"1.png");
    ADDBUTTON(32, @"2", @"2.png");
    ADDBUTTON(33, @"3", @"3.png");
    ADDBUTTON(34, @"mul", @"mul.png");
    ADDBUTTON(35, @"div", @"div.png");
    ADDBUTTON(36, @"M-", @"Msub.png");
    ADDBUTTON(37, @"EE", @"timestenpowerx.png");
    ADDBUTTON(38, @"0", @"0.png");
    ADDBUTTON(39, @".", @"point.png");
    ADDBUTTON2(40, @"=", @"equ.png");
    
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
