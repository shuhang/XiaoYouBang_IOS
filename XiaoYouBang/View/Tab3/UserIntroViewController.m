//
//  UserIntroViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/11.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "UserIntroViewController.h"
#import "Tool.h"
#import "AddCommentViewController.h"

@interface UserIntroViewController ()
{
    UILabel * label;
    UIScrollView * scrollView;
}
@end

@implementation UserIntroViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self setupTitle:[NSString stringWithFormat:@"%@的自我介绍", self.userName]];
    
    if( [Tool judgeIsMe:self.userId] )
    {
        [self setupNextButtonTitle:@"编辑"];
    }
    else
    {
        [self hideNextButton];
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.directionalLockEnabled = YES;
    [self.view addSubview:scrollView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, Screen_Width - 30, 0 )];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label setAttributedText:[Tool getModifyString:self.intro]];
    label.textColor = Color_Heavy_Gray;
    label.font = [UIFont systemFontOfSize:Text_Size_Small];
    [label sizeToFit];
    [scrollView addSubview:label];
    
    scrollView.contentSize = CGSizeMake( Screen_Width, [Tool getBottom:label] - 30 );
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editIntro:) name:EditIntroSuccess object:nil];
}

- ( void ) editIntro : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    self.intro = [dic objectForKey:@"info"];
    
    label.text = self.intro;
    [label sizeToFit];
    
    scrollView.contentSize = CGSizeMake( Screen_Width, [Tool getBottom:label] - 30 );
}

- ( void ) doBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EditIntroSuccess object:nil];
    [super doBack];
}

- ( void ) doNext
{
    AddCommentViewController * controller = [AddCommentViewController new];
    controller.type = 4;
    controller.info = self.intro;
    controller.isEdit = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
