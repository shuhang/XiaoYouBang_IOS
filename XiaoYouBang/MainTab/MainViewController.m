//
//  MainViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/14.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
}

- ( void ) setupTabbarItem
{
    NSArray * array = self.controller.viewControllers;
    NSMutableArray * arrayNew = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop)
     {
         UITabBarItem * item = nil;
         switch( idx )
         {
             case 0:
             {
                 item = [[UITabBarItem alloc] initWithTitle:@"广场" image:nil tag:1];
                 [item setTitlePositionAdjustment:UIOffsetMake( 0, -10 )];
                 break;
             }
             case 1:
             {
                 item = [[UITabBarItem alloc] initWithTitle:@"相关" image:nil tag:1];
                 [item setTitlePositionAdjustment:UIOffsetMake( 0, -10 )];
                 break;
             }
             case 2:
             {
                 item = [[UITabBarItem alloc] initWithTitle:@"校友录" image:nil tag:1];
                 [item setTitlePositionAdjustment:UIOffsetMake( 0, -10 )];
                 break;
             }
         }
         viewController.tabBarItem = item;
         [arrayNew addObject:viewController];
     }];
    self.controller.viewControllers = arrayNew;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], UITextAttributeFont, [UIColor blackColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
}

@end
