//
//  Tab1ViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "Tab3ViewController.h"

@interface Tab3ViewController ()
{
    UILabel * titleLabel;
}
@end

@implementation Tab3ViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    if( OSVersionIsAtLast7 )
    {
        [self.navigationController.navigationBar setBarTintColor:Bg_Red];
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:Bg_Red];
    }
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 100, 30 )];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"校友录";
    self.navigationItem.titleView = titleLabel;
}

@end