//
//  DZMenuViewController.m
//  ScienceCalculator
//
//  Created by 董 政 on 12-3-6.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import "DZMenuViewController.h"

#define LS(key) \
    [[NSBundle mainBundle] \
    localizedStringForKey:(key) value:@"" table:nil]

@implementation DZMenuViewController

@synthesize forcedScientificNotation;
@synthesize advancedMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        NSLog(@"recreate");
        self.title = LS(@"Menu");
        self.advancedMode = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 79, 27)];
        [self.advancedMode addTarget:self 
                              action:@selector(advancedModeChanged) 
                    forControlEvents:UIControlEventValueChanged];
        self.forcedScientificNotation = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 79, 27)];
        [self.forcedScientificNotation addTarget:self 
                              action:@selector(forcedScientificNotationChanged) 
                    forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)createModel
{
    self.dataSource =
    [TTSectionedDataSource dataSourceWithObjects:
     LS(@"Settings"),
     [TTTableControlItem itemWithCaption:LS(@"Advanced Mode")
                                 control:self.advancedMode],
     [TTTableControlItem itemWithCaption:LS(@"Scientific Notation")
                                 control:self.forcedScientificNotation],
     LS(@"History"),
     [TTTableTextItem itemWithText:LS(@"Show History") URL:nil],
     [TTTableTextItem itemWithText:LS(@"Clear History") URL:nil],
     nil];
}

- (void)advancedModeChanged
{
    NSLog(@"Advanced mode changed to: %@", self.advancedMode);
}

- (void)forcedScientificNotationChanged 
{
    NSLog(@"Forced scientific notation changed to: %d", self.forcedScientificNotation.on);
}

@end
