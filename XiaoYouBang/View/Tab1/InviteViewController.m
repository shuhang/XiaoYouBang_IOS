//
//  InviteViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/12.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "InviteViewController.h"
#import "GCPlaceholderTextView.h"
#import "SVProgressHUD.h"
#import "NetWork.h"
#import "MyDatabaseHelper.h"
#import "InviteEntity.h"
#import "ChooseInviteViewController.h"
#import <UIImageView+WebCache.h>

@interface InviteViewController ()
{
    UIImageView * headImageView;
    UIImageView * symbolImageView;
    UITextField * fieldName;
    GCPlaceholderTextView * inputInfo;
}
@end

@implementation InviteViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"邀请回答"];
    [self setupNextButtonTitle:@"完成"];
    self.canInvite = NO;
    self.view.backgroundColor = Color_With_Rgb( 255, 255, 255, 1 );
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 15, 84, 50, 50 )];
    headImageView.image = [UIImage imageNamed:@"head_default"];
    headImageView.userInteractionEnabled = YES;
    [self.view addSubview:headImageView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)];
    [headImageView addGestureRecognizer:gesture];
    
    fieldName = [[UITextField alloc] initWithFrame:CGRectMake( 75, 94, Screen_Width - 100, 30 )];
    fieldName.placeholder = @"输入姓名，或点击头像选择";
    fieldName.backgroundColor = [UIColor whiteColor];
    fieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldName setBorderStyle:UITextBorderStyleNone];
    [fieldName setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [fieldName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:fieldName];
    
    symbolImageView = [[UIImageView alloc] initWithFrame:CGRectMake( Screen_Width - 25, 99, 15, 15 )];
    symbolImageView.image = [UIImage imageNamed:@"no"];
    [self.view addSubview:symbolImageView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake( 75, 133.5, Screen_Width - 85, 0.5 )];
    line.backgroundColor = Color_Gray;
    [self.view addSubview:line];
    
    inputInfo = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 10, 169, Screen_Width - 20, Screen_Height - 169 )];
    inputInfo.font = [UIFont systemFontOfSize:Text_Size_Big];
    inputInfo.placeholder = @"请写下你的邀请理由，将发表在评论区...";
    [self.view addSubview:inputInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseUser:) name:ChooseInviter object:nil];
}

- (void) textFieldDidChange:(UITextField *) TextField
{
    self.name = TextField.text;
    MyDatabaseHelper * helper = [MyDatabaseHelper new];
    UserEntity * entity = [helper getUserByName:self.name];
    if( entity != nil )
    {
        self.canInvite = YES;
        [headImageView sd_setImageWithURL:[NSURL URLWithString:entity.headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
        symbolImageView.image = [UIImage imageNamed:@"yes"];
    }
    else
    {
        self.canInvite = NO;
        headImageView.image = [UIImage imageNamed:@"head_default"];
        symbolImageView.image = [UIImage imageNamed:@"no"];
    }
}

- ( void ) chooseUser : ( NSNotification * ) noti
{
    NSDictionary * dic = [noti userInfo];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:dic[ @"headUrl" ]] placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.name = dic[ @"userName" ];
    self.userId = dic[ @"userId" ];
    fieldName.text = dic[ @"userName" ];
    symbolImageView.image = [UIImage imageNamed:@"yes"];
    self.canInvite = YES;
}

- ( void ) clickHead : (UITapGestureRecognizer *)tap
{
    [self loadAnswererId];
}

- ( void ) doBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChooseInviter object:nil];
    [super doBack];
}

- ( void ) loadAnswererId
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/question/%@/answerusers", self.questionId];
    [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
     {
         if( [result[ @"result" ] intValue] == 3000 )
         {
             [self loadAnswererSuccess:result];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"加载失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"加载失败"];
     }];
}

- ( void ) loadAnswererSuccess : ( NSDictionary * ) result
{
    NSMutableDictionary * dictionAnswerers = [NSMutableDictionary dictionary];
    NSArray * array = result[ @"userids" ];
    for( NSString * item in array )
    {
        [dictionAnswerers setObject:[NSNumber numberWithBool:YES] forKey:item];
    }
    
    NSMutableDictionary * dictionInviters = [NSMutableDictionary dictionary];
    for( InviteEntity * item in self.arrayInviters )
    {
        [dictionInviters setObject:[NSNumber numberWithBool:YES] forKey:item.inviteUserId];
    }
    
    if( self.arrayUsers.count == 0 )
    {
        MyDatabaseHelper * helper = [MyDatabaseHelper new];
        self.arrayUsers = [helper getUserList];
        self.arrayUsers = ( NSMutableArray * )[self.arrayUsers sortedArrayUsingFunction:sortByName3 context:NULL];
    }
    
    for( UserEntity * user in self.arrayUsers )
    {
        if( [dictionAnswerers objectForKey:user.userId] )
        {
            user.hasAnswered = YES;
        }
        if( [dictionInviters objectForKey:user.userId] )
        {
            user.hasInvited = YES;
        }
    }
    
    ChooseInviteViewController * controller = [ChooseInviteViewController new];
    controller.arrayUsers = self.arrayUsers;
    [SVProgressHUD dismiss];
    [self.navigationController pushViewController:controller animated:YES];
}

NSInteger sortByName3( id u1, id u2, void *context )
{
    UserEntity * user1 = ( UserEntity * ) u1;
    UserEntity * user2 = ( UserEntity * ) u2;
    return [user1.name localizedCompare:user2.name];
}

- ( void ) doNext
{
    if( !self.canInvite )
    {
        [SVProgressHUD showErrorWithStatus:@"请选择邀请人"];
        return;
    }
    self.reason = inputInfo.text;
    if( self.reason.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入邀请理由"];
        return;
    }
    
    [self doInvite];
}

- ( void ) doInvite
{
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
    [request setValue:self.userId forKey:@"target"];
    [request setValue:self.reason forKey:@"words"];
    [request setValue:[NSNumber numberWithInt:0] forKey:@"inviteType"];
    
    NSString * url = [NSString stringWithFormat:@"api/question/%@/invite", self.questionId];
    [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 3000 )
         {
             [self inviteSuccess : result[ @"time" ]];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"取消失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"取消失败"];
     }];
}

- ( void ) inviteSuccess : ( NSString * ) time
{
    [SVProgressHUD dismiss];
    NSDictionary * info = @{ @"userName" : self.name, @"time" : time, @"value" : self.reason };
    [[NSNotificationCenter defaultCenter] postNotificationName:InviteUserSuccess object:nil userInfo:info];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
