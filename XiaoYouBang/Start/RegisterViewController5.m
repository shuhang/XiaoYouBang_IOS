//
//  RegisterViewController5.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "RegisterViewController5.h"
#import "NetWork.h"
#import "Tool.h"
#import "GCPlaceholderTextView.h"

@interface RegisterViewController5 ()
{
    UILabel * textLabel;
    //UITextView * fieldInput;
    GCPlaceholderTextView * fieldInput;
}
@end

@implementation RegisterViewController5

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"留言板-主人寄语"];
    [self setupNextButtonTitle:@"完成"];
    self.view.backgroundColor = Color_Light_Gray;
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake( 30, 84, Screen_Width - 40, 30 )];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = Color_Gray;
    textLabel.text = @"请在你的留言板上，跟大家说句话吧";
    textLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    [self.view addSubview:textLabel];
    
    fieldInput = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake( 20, 124, Screen_Width - 40, 200 )];
    fieldInput.layer.cornerRadius = 6;
    fieldInput.layer.masksToBounds = YES;
    fieldInput.layer.borderColor = Color_Gray.CGColor;
    fieldInput.layer.borderWidth = 0.5f;
    fieldInput.font = [UIFont systemFontOfSize:Text_Size_Small];
    [self.view addSubview:fieldInput];
}

- ( void ) doNext
{
    FORCE_CLOSE_KEYBOARD;
    
    self.leaveWord = fieldInput.text;
    if( self.leaveWord.length < 1 || self.leaveWord.length > 300 )
    {
        [SVProgressHUD showErrorWithStatus:@"寄语300个字以内"];
        return;
    }
    
    [self doUploadHeadImage];
}

- ( void ) doUploadHeadImage
{
    [SVProgressHUD showWithStatus:@"正在注册" maskType:SVProgressHUDMaskTypeGradient];
    __block RegisterViewController5 * temp = self;
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^
    {
        NSDictionary * result = [[NetWork shareInstance] uploadHeadImage:[NSString stringWithFormat:@"signup/upload?phone=%@&key=%@&code=123456", self.phone, self.key] fileName:@"head.jpg" fileData:self.headImageData mimeType:@"image/jpeg"];
        if( result == nil || [result[ @"result" ] intValue] != 2000 )
        {
            dispatch_async
            (
                dispatch_get_main_queue(), ^
                {
                    [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
                }
            );
        }
        else
        {
            self.headUrl = [NSString stringWithFormat:@"%@", result[ @"headUrl" ] ];
            [temp doRegister];
        }
    });
}

- ( void ) doRegister
{
    NSDictionary * request = @{
                               @"key" : self.key,
                               @"inviteCode" : self.code,
                               @"code": @"123456",
                               @"username" : self.phone,
                               @"password" : self.password,
                               @"name" : self.name,
                               @"headUrl" : self.headUrl,
                               @"sex" : [NSNumber numberWithInt:self.sex],
                               @"birthyear" : self.birthYear,
                               @"pku" : [Tool getPkuShortByLong:self.pku],
                               @"hometown" : self.oldHome,
                               @"base" : self.nowHome,
                               @"qq" : self.net,
                               @"company" : self.company,
                               @"department" : self.part,
                               @"job" : self.job,
                               @"leaveWord" : self.leaveWord,
                               @"device" : @"",
                               @"tags" : self.tags
                              };
    [[NetWork shareInstance] httpRequestWithPostPut:@"signup/" params:request method:@"POST" success:^( NSDictionary * result )
     {
         NSNumber * code = [result objectForKey:@"result"];
         if( [code intValue] == 2000 )
         {
             NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:[NSString stringWithFormat:@"%@", [result objectForKey:@"id"]] forKey:@"userId"];
             [userDefaults setObject:[NSString stringWithFormat:@"%@", [result objectForKey:@"token"]] forKey:@"token"];
             [userDefaults setObject:self.name forKey:@"name"];
             [userDefaults setObject:[NSNumber numberWithInt:self.sex] forKey:@"sex"];
             [userDefaults setObject:[NSString stringWithFormat:@"%@%@", Image_Server_Url, self.headUrl] forKey:@"headUrl"];
             [userDefaults setObject:[Tool getPkuShortByLong:self.pku] forKey:@"pku"];
             [userDefaults setObject:self.nowHome forKey:@"base"];
             [userDefaults setObject:self.oldHome forKey:@"hometown"];
             [userDefaults setObject:self.net forKey:@"qq"];
             [userDefaults setObject:self.company forKey:@"company"];
             [userDefaults setObject:self.part forKey:@"department"];
             [userDefaults setObject:self.job forKey:@"job"];
             [userDefaults setObject:@"" forKey:@"intro"];
             [userDefaults setObject:[NSString stringWithFormat:@"%@", self.birthYear] forKey:@"birthyear"];
             [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"version"];
             [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"praisedCount"];
             [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"answerCount"];
             [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"questionCount"];
             [userDefaults setObject:self.tags forKey:@"tags"];
             [userDefaults setObject:@"" forKey:@"inviteUserName"];
             [userDefaults setObject:@"" forKey:@"inviteUserHeadUrl"];
             [userDefaults setObject:@"" forKey:@"inviteUserId"];
             [userDefaults synchronize];
             
             [self registerSuccess];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"注册失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"登陆失败"];
     }];
}

- ( void ) registerSuccess
{
    [SVProgressHUD dismiss];
    self.tabBarController.tabBar.hidden = NO;
    BaseViewController * controller = [self.navigationController.viewControllers objectAtIndex:0];
    controller.hasRefreshed = NO;
    [self.navigationController popToViewController:controller animated:YES];
}

@end
