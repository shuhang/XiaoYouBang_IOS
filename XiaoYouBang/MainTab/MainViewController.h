//
//  MainViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property( nonatomic, strong ) UITabBarController * controller;

- ( void ) setupTabbarItem;

@end
