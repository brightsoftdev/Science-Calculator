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
#pragma mark Private extention

@interface DZViewController ()

@property (nonatomic,retain) DZClassicCalculator * calculator;
@property (nonatomic,retain) NSMutableArray * allButtons;
@property (nonatomic,retain) DZImagePool * imagePool;
@property (nonatomic,retain) UIView * btnView1;
@property (nonatomic,retain) UIView * btnView2;

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

@end

#pragma mark - 
#pragma mark Implementation start here

@implementation DZViewController

@synthesize allButtons;
@synthesize imagePool;
@synthesize calculator;
@synthesize btnView1,btnView2;

#pragma mark -
#pragma mark buttonPress actions

- (void)menuButtonPressed:(id)sender
{
    TTNavigator * navigator = [TTNavigator navigator];
    TTURLAction * action = [[TTURLAction actionWithURLPath:@"tt://menu"]applyAnimated:YES];
    [navigator openURLAction:action];
}
                 
#pragma mark -
#pragma mark Utilities

#pragma mark -
#pragma mark add buttons and build views

- (void)buildUpView
{
    self.btnView1 = [[UIView alloc]
                     initWithFrame:CGRectMake(0, 124, 320, 336)];
    [self addButton:1:0:@"Fn":0:@selector(menuButtonPressed:)];
    [self addButton:1:1:@"M+":1:@selector(menuButtonPressed:)];
    [self addButton:1:2:@"M−":1:@selector(menuButtonPressed:)];
    [self addButton:1:3:@"MR":1:@selector(menuButtonPressed:)];
    [self addButton:1:4:@"MC":1:@selector(menuButtonPressed:)];
    [self addButton:1:5:@"(":1:@selector(menuButtonPressed:)];
    [self addButton:1:6:@")":1:@selector(menuButtonPressed:)];
    [self addButton:1:7:@"C":1:@selector(menuButtonPressed:)];
    [self addButton:1:8:@"CE":1:@selector(menuButtonPressed:)];
    [self addButton:1:9:@"DEL":1:@selector(menuButtonPressed:)];
    [self addButton:1:10:@"÷":1:@selector(menuButtonPressed:)];
    [self addButton:1:11:@"7":1:@selector(menuButtonPressed:)];
    [self addButton:1:12:@"8":1:@selector(menuButtonPressed:)];
    [self addButton:1:13:@"9":1:@selector(menuButtonPressed:)];
    [self addButton:1:14:@"×10ⁿ":1:@selector(menuButtonPressed:)];
    [self addButton:1:15:@"×":1:@selector(menuButtonPressed:)];
    [self addButton:1:16:@"4":1:@selector(menuButtonPressed:)];
    [self addButton:1:17:@"5":1:@selector(menuButtonPressed:)];
    [self addButton:1:18:@"6":1:@selector(menuButtonPressed:)];
    [self addButton:1:19:@"±":1:@selector(menuButtonPressed:)];
    [self addButton:1:20:@"−":1:@selector(menuButtonPressed:)];
    [self addButton:1:21:@"1":1:@selector(menuButtonPressed:)];
    [self addButton:1:22:@"2":1:@selector(menuButtonPressed:)];
    [self addButton:1:23:@"3":1:@selector(menuButtonPressed:)];
    [self addButton:1:24:@"F-E":1:@selector(menuButtonPressed:)];
    [self addButton:1:25:@"+":1:@selector(menuButtonPressed:)];
    [self addButton:1:26:@"0":1:@selector(menuButtonPressed:)];
    [self addButton:1:27:@".":1:@selector(menuButtonPressed:)];
    [self addButton:1:28:@"ans":1:@selector(menuButtonPressed:)];
    [self addButton:1:29:@"=":1:@selector(menuButtonPressed:)];
    self.btnView2 = [[UIView alloc]
                     initWithFrame:CGRectMake(0, 124, 320, 336)];
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
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 6);
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
               ofFont:@"Helvetica-Bold" :32 :[UIColor whiteColor]
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
    self.imagePool = [DZImagePool new];
    self.allButtons = [NSMutableArray array];
    [self buildUpView];
    [self.view addSubview:btnView1];
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
