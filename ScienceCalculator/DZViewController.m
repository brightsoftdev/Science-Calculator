//
//  DZViewController.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-2-26.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZViewController.h"

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
    if (title != nil) {
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
        [self moveButtonAtIndex:0 toFrameRect:CGRectMake(100, 100, 50, 42)];
    } else {
        [self moveButtonAtIndex:0 toFrameRect:CGRectMake(200, 50, 50, 42)];
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
    [self addButtonAtIndex:0 
                  withText:@"ln" 
              orImageNamed:nil
           backgroundImage:bkImg 
    backgroundImagePressed:pressedImg];
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
