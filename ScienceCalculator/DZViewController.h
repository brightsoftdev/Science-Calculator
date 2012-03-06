//
//  DZViewController.h
//  ScienceCalculator
//
//  Created by 董 政 on 12-2-26.
//  Copyright (c) 2012年 复旦大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZViewController : UIViewController 

@property (nonatomic,retain) IBOutlet UIImageView * screenImgView;
@property (nonatomic,retain) IBOutlet UIImageView * ledDegRad;
@property (nonatomic,retain) IBOutlet UIImageView * ledNormSci;
@property (nonatomic,retain) IBOutlet UIImageView * ledM;
@property (nonatomic,retain) IBOutlet UIButton * menu;

- (IBAction)menuButtonPressed:(id)sender;

@end
