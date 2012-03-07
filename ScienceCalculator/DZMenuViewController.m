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

@interface DZMenuViewController ()
- (void)userDefaultsChanged:(NSNotification *)notification;
@end

@implementation DZMenuViewController

@synthesize forcedScientificNotation;
@synthesize advancedMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        //NSLog(@"recreate");
        self.title = LS(@"Menu");
        self.advancedMode = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 79, 27)];
        [self.advancedMode addTarget:self 
                              action:@selector(advancedModeChanged) 
                    forControlEvents:UIControlEventValueChanged];
        self.forcedScientificNotation = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 79, 27)];
        [self.forcedScientificNotation addTarget:self 
                              action:@selector(forcedScientificNotationChanged) 
                    forControlEvents:UIControlEventValueChanged];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(userDefaultsChanged:)
         name:NSUserDefaultsDidChangeNotification
         object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

- (void)userDefaultsChanged:(NSNotification *)notification
{
    self.forcedScientificNotation.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"scientific_notation"];
    self.advancedMode.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"advanced_mode"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self userDefaultsChanged:nil];
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
    [[NSUserDefaults standardUserDefaults]
     setBool:self.advancedMode.on 
     forKey:@"advanced_mode"];
}

- (void)forcedScientificNotationChanged 
{
    [[NSUserDefaults standardUserDefaults]
     setBool:self.forcedScientificNotation.on 
     forKey:@"scientific_notation"];
}

@end
