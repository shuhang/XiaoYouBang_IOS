//
//  BaseViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/23.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface BaseViewController : UIViewController
{
    UILabel * titleLabel;
    UIButton * buttonNext;
    UIButton * buttonBack;
}

@property( nonatomic, assign ) BOOL hasRefreshed;

- ( void ) doBack;
- ( void ) doNext;
- ( void ) doRefreshSelfView;
- ( void ) setupTitle : ( NSString * ) text;
- ( void ) setupNextButtonTitle : ( NSString * ) text;
- ( void ) hideBackButton;
- ( void ) hideNextButton;
- ( void ) adjustTextField : ( UITextField * ) field;

@end
