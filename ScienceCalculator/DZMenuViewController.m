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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.title = LS(@"Menu");
    }
    return self;
}

- (void)dealloc
{
}

- (void)createModel
{
    self.dataSource =
    [TTSectionedDataSource dataSourceWithObjects:
     LS(@"Hello"),
     [TTTableTextItem itemWithText:LS(@"Hello World") URL:nil],
     nil];
}

@end
