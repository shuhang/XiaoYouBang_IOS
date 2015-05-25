//
//  EditInfoViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "EditInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "Tool.h"
#import "NetWork.h"

@interface EditInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    UIScrollView * scrollView;
    UIImageView * headImageView;
    UITextField * fieldBirthday;
    UITextField * fieldNowHome;
    UITextField * fieldOldHome;
    UITextField * fieldNet;
    UITextField * fieldCompany;
    UITextField * fieldPart;
    UITextField * fieldJob;
    UITextField * fieldTag1;
    UITextField * fieldTag2;
    UITextField * fieldTag3;
    UITextField * fieldTag4;
    UITextField * fieldTag5;
    
    UIActionSheet * sheetPhoto;
}
@end

@implementation EditInfoViewController

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"修改个人资料"];
    [self setupNextButtonTitle:@"完成"];
    self.tabBarController.tabBar.hidden = YES;
    [self.view setBackgroundColor:Color_Light_Gray];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height + 50 )];
    [self.view addSubview:scrollView];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 15, 15, 40, 40 )];
    headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * gestureHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)];
    [headImageView addGestureRecognizer:gestureHead];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    [scrollView addSubview:headImageView];
    
    UILabel * labelName = [[UILabel alloc] initWithFrame:CGRectMake( 65, 15, self.entity.name.length * 13, 15 )];
    labelName.font = [UIFont systemFontOfSize:Text_Size_Small];
    labelName.textColor = [UIColor blackColor];
    labelName.text = self.entity.name;
    [scrollView addSubview:labelName];
    
    UIImageView * sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake( [Tool getRight:labelName] + 10, headImageView.frame.origin.y + 3, 10, 10 )];
    if( self.entity.sex == 0 )
    {
        [sexImageView setImage:[UIImage imageNamed:@"female_color"]];
    }
    else
    {
        [sexImageView setImage:[UIImage imageNamed:@"male_color"]];
    }
    [scrollView addSubview:sexImageView];
    
    UILabel * labelPku = [[UILabel alloc] initWithFrame:CGRectMake( 65, 40, Screen_Width - 70, 15 )];
    labelPku.font = [UIFont systemFontOfSize:Text_Size_Small];
    labelPku.textColor = Color_Gray;
    labelPku.text = [NSString stringWithFormat:@"北京大学 %@", [Tool getPkuLongByShort:self.entity.pku]];
    [scrollView addSubview:labelPku];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:headImageView] + 10, Screen_Width, 0.5)];
    line.backgroundColor = Color_Heavy_Gray;
    [scrollView addSubview:line];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:line] + 10, Screen_Width - 10, 15 )];
    label1.font = [UIFont systemFontOfSize:Text_Size_Small];
    label1.textColor = Color_Gray;
    label1.text = @"出生年份";
    [scrollView addSubview:label1];
    
    fieldBirthday = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:label1] + 5, Screen_Width - 40, 35 )];
    fieldBirthday.placeholder = @"出生年份";
    fieldBirthday.backgroundColor = [UIColor whiteColor];
    fieldBirthday.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldBirthday setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldBirthday setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldBirthday];
    [scrollView addSubview:fieldBirthday];
    fieldBirthday.text = self.entity.birthday;
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:fieldBirthday] + 5, Screen_Width - 10, 15 )];
    label2.font = [UIFont systemFontOfSize:Text_Size_Small];
    label2.textColor = Color_Gray;
    label2.text = @"现居地";
    [scrollView addSubview:label2];
    
    fieldNowHome = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:label2] + 5, Screen_Width - 40, 35 )];
    fieldNowHome.placeholder = @"现居地";
    fieldNowHome.backgroundColor = [UIColor whiteColor];
    fieldNowHome.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldNowHome setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldNowHome setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldNowHome];
    [scrollView addSubview:fieldNowHome];
    fieldNowHome.text = self.entity.nowHome;
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:fieldNowHome] + 5, Screen_Width - 10, 15 )];
    label3.font = [UIFont systemFontOfSize:Text_Size_Small];
    label3.textColor = Color_Gray;
    label3.text = @"故乡";
    [scrollView addSubview:label3];
    
    fieldOldHome = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:label3] + 5, Screen_Width - 40, 35 )];
    fieldOldHome.placeholder = @"故乡";
    fieldOldHome.backgroundColor = [UIColor whiteColor];
    fieldOldHome.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldOldHome setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldOldHome setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldOldHome];
    [scrollView addSubview:fieldOldHome];
    fieldOldHome.text = self.entity.oldHome;
    
    UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:fieldOldHome] + 5, Screen_Width - 10, 15 )];
    label4.font = [UIFont systemFontOfSize:Text_Size_Small];
    label4.textColor = Color_Gray;
    label4.text = @"网络联系方式，电邮/QQ/微信";
    [scrollView addSubview:label4];
    
    fieldNet = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:label4] + 5, Screen_Width - 40, 35 )];
    fieldNet.placeholder = @"网络联系方式，电邮/QQ/微信";
    fieldNet.backgroundColor = [UIColor whiteColor];
    fieldNet.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldNet setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldNet setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldNet];
    [scrollView addSubview:fieldNet];
    fieldNet.text = self.entity.qq;
    
    UILabel * label5 = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:fieldNet] + 5, Screen_Width - 10, 15 )];
    label5.font = [UIFont systemFontOfSize:Text_Size_Small];
    label5.textColor = Color_Gray;
    label5.text = @"工作单位/公司/机构";
    [scrollView addSubview:label5];
    
    fieldCompany = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:label5] + 5, Screen_Width - 40, 35 )];
    fieldCompany.placeholder = @"工作单位/公司/机构";
    fieldCompany.backgroundColor = [UIColor whiteColor];
    fieldCompany.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldCompany setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldCompany setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldCompany];
    [scrollView addSubview:fieldCompany];
    fieldCompany.text = self.entity.job1;
    
    UILabel * label6 = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:fieldCompany] + 10, Screen_Width - 10, 15 )];
    label6.font = [UIFont systemFontOfSize:Text_Size_Small];
    label6.textColor = Color_Gray;
    label6.text = @"所在部门";
    [scrollView addSubview:label6];
    
    fieldPart = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:label6] + 5, Screen_Width - 40, 35 )];
    fieldPart.placeholder = @"所在部门";
    fieldPart.backgroundColor = [UIColor whiteColor];
    fieldPart.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldPart setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldPart setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldPart];
    [scrollView addSubview:fieldPart];
    fieldPart.text = self.entity.job2;
    
    UILabel * label7 = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:fieldPart] + 10, Screen_Width - 10, 15 )];
    label7.font = [UIFont systemFontOfSize:Text_Size_Small];
    label7.textColor = Color_Gray;
    label7.text = @"职位";
    [scrollView addSubview:label7];
    
    fieldJob = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:label7] + 5, Screen_Width - 40, 35 )];
    fieldJob.placeholder = @"职位";
    fieldJob.backgroundColor = [UIColor whiteColor];
    fieldJob.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldJob setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldJob setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldJob];
    [scrollView addSubview:fieldJob];
    fieldJob.text = self.entity.job3;
    
    UILabel * label8 = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:fieldJob] + 10, Screen_Width - 10, 15 )];
    label8.font = [UIFont systemFontOfSize:Text_Size_Small];
    label8.textColor = Color_Gray;
    label8.text = @"标签";
    [scrollView addSubview:label8];
    
    fieldTag1 = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:label8] + 5, Screen_Width - 40, 35 )];
    fieldTag1.placeholder = @"标签1";
    fieldTag1.backgroundColor = [UIColor whiteColor];
    fieldTag1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag1 setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldTag1 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag1];
    [scrollView addSubview:fieldTag1];
    fieldTag1.text = [self.entity.tagArray objectAtIndex:0];
    
    fieldTag2 = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:fieldTag1] + 5, Screen_Width - 40, 35 )];
    fieldTag2.placeholder = @"标签2";
    fieldTag2.backgroundColor = [UIColor whiteColor];
    fieldTag2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag2 setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldTag2 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag2];
    [scrollView addSubview:fieldTag2];
    fieldTag2.text = [self.entity.tagArray objectAtIndex:1];
    
    fieldTag3 = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:fieldTag2] + 5, Screen_Width - 40, 35 )];
    fieldTag3.placeholder = @"标签3";
    fieldTag3.backgroundColor = [UIColor whiteColor];
    fieldTag3.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag3 setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldTag3 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag3];
    [scrollView addSubview:fieldTag3];
    fieldTag3.text = [self.entity.tagArray objectAtIndex:2];
    
    fieldTag4 = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:fieldTag3] + 5, Screen_Width - 40, 35 )];
    fieldTag4.placeholder = @"标签4";
    fieldTag4.backgroundColor = [UIColor whiteColor];
    fieldTag4.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag4 setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldTag4 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag4];
    [scrollView addSubview:fieldTag4];
    fieldTag4.text = [self.entity.tagArray objectAtIndex:3];
    
    fieldTag5 = [[UITextField alloc] initWithFrame:CGRectMake( 20, [Tool getBottom:fieldTag4] + 5, Screen_Width - 40, 35 )];
    fieldTag5.placeholder = @"标签5";
    fieldTag5.backgroundColor = [UIColor whiteColor];
    fieldTag5.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldTag5 setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldTag5 setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldTag5];
    [scrollView addSubview:fieldTag5];
    fieldTag5.text = [self.entity.tagArray objectAtIndex:4];
    
    scrollView.contentSize = CGSizeMake( Screen_Width, [Tool getBottom:fieldTag5] + 10 );
}

- ( void ) doJudgeInput
{
    NSString * birthday = fieldBirthday.text;
    if( birthday.length != 4 )
    {
        [SVProgressHUD showErrorWithStatus:@"生日年份输入不正确"];
        return;
    }
    self.entity.birthday = birthday;
    
    NSString * nowHome = fieldNowHome.text;
    if( nowHome.length < 1 || nowHome.length > 10 )
    {
        [SVProgressHUD showErrorWithStatus:@"现居地10个字以内"];
        return;
    }
    self.entity.nowHome = nowHome;
    
    NSString * oldHome = fieldOldHome.text;
    if( oldHome.length > 10 )
    {
        [SVProgressHUD showErrorWithStatus:@"故乡10个字以内"];
        return;
    }
    self.entity.oldHome = oldHome;
    
    NSString * qq = fieldNet.text;
    if( qq.length < 1 || qq.length > 40 )
    {
        [SVProgressHUD showErrorWithStatus:@"网络联系方式40个字以内"];
        return;
    }
    self.entity.qq = qq;
    
    NSString * job1 = fieldCompany.text;
    if( job1.length < 1 || job1.length > 20 )
    {
        [SVProgressHUD showErrorWithStatus:@"工作单位20个字以内"];
        return;
    }
    self.entity.job1 = job1;
    
    NSString * job2 = fieldPart.text;
    if( job2.length > 10 )
    {
        [SVProgressHUD showErrorWithStatus:@"所在部门10个字以内"];
        return;
    }
    self.entity.job2 = job2;
    
    NSString * job3 = fieldJob.text;
    if( job3.length < 1 || job3.length > 10 )
    {
        [SVProgressHUD showErrorWithStatus:@"职位10个字以内"];
        return;
    }
    self.entity.job3 = job3;
    
    NSString * tag1 = fieldTag1.text;
    if( tag1.length > 6 )
    {
        [SVProgressHUD showErrorWithStatus:@"标签6个字以内"];
        return;
    }
    NSString * tag2 = fieldTag2.text;
    if( tag2.length > 6 )
    {
        [SVProgressHUD showErrorWithStatus:@"标签6个字以内"];
        return;
    }
    NSString * tag3 = fieldTag3.text;
    if( tag3.length > 6 )
    {
        [SVProgressHUD showErrorWithStatus:@"标签6个字以内"];
        return;
    }
    NSString * tag4 = fieldTag4.text;
    if( tag4.length > 6 )
    {
        [SVProgressHUD showErrorWithStatus:@"标签6个字以内"];
        return;
    }
    NSString * tag5 = fieldTag5.text;
    if( tag5.length > 6 )
    {
        [SVProgressHUD showErrorWithStatus:@"标签6个字以内"];
        return;
    }
    self.entity.tagArray = [NSMutableArray arrayWithObjects:tag1, tag2, tag3, tag4, tag5, nil];
    
    if( self.hasChangeHead )
    {
        [self startUploadHead];
    }
    else
    {
        [self startChangeInfo];
    }
}

- ( void ) doNext
{
    [self doJudgeInput];
}

- ( void ) startUploadHead
{
    [SVProgressHUD showWithStatus:@"正在更新头像" maskType:SVProgressHUDMaskTypeGradient];
    __block EditInfoViewController * temp = self;
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^
    {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * url = [NSString stringWithFormat:@"api/user/upload?token=%@", [userDefaults objectForKey:@"token"]];
        NSDictionary * result = [[NetWork shareInstance] uploadHeadImage:url fileName:@"head.jpg" fileData:self.headImageData mimeType:@"image/jpeg"];
        if( result == nil || [result[ @"result" ] intValue] != 1000 )
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
            temp.headUrl = [NSString stringWithFormat:@"%@", result[ @"headUrl" ] ];
            temp.entity.headUrl = [NSString stringWithFormat:@"%@%@", Image_Server_Url, result[ @"headUrl" ] ];
            [temp startChangeInfo];
        }
    });
}

- ( void ) startChangeInfo
{
    dispatch_async
    (
         dispatch_get_main_queue(), ^
         {
             [SVProgressHUD showWithStatus:@"正在更新个人资料" maskType:SVProgressHUDMaskTypeGradient];
         }
    );
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * request = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"token" : [userDefaults objectForKey:@"token"],
                                                                                    @"birthyear" : self.entity.birthday,
                                                                                    @"hometown" : self.entity.oldHome,
                                                                                    @"base" : self.entity.nowHome,
                                                                                    @"qq" : self.entity.qq,
                                                                                    @"company" : self.entity.job1,
                                                                                    @"department" : self.entity.job2,
                                                                                    @"job" : self.entity.job3,
                                                                                    @"tags" : self.entity.tagArray
                                                                                    }];
    if( self.hasChangeHead )
    {
        [request setObject:self.headUrl forKey:@"headUrl"];
    }
    [[NetWork shareInstance] httpRequestWithPostPut:@"api/user" params:request method:@"PUT" success:^(NSDictionary * result)
     {
         int code = [result[ @"result"] intValue];
         if( code == 1000 )
         {
             [self changeSuccess];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"更新失败"];
         }
     }
     error:^(NSError * error)
     {
         NSLog( @"%@", error );
         [SVProgressHUD showErrorWithStatus:@"更新失败"];
     }];
}

- ( void ) changeSuccess
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.entity.headUrl forKey:@"headUrl"];
    [userDefaults setObject:self.entity.nowHome forKey:@"base"];
    [userDefaults setObject:self.entity.oldHome forKey:@"hometown"];
    [userDefaults setObject:self.entity.qq forKey:@"qq"];
    [userDefaults setObject:self.entity.job1 forKey:@"company"];
    [userDefaults setObject:self.entity.job2 forKey:@"department"];
    [userDefaults setObject:self.entity.job3 forKey:@"job"];
    [userDefaults setObject:self.entity.birthday forKey:@"birthyear"];
    [userDefaults setObject:self.entity.tagArray forKey:@"tags"];
    [userDefaults synchronize];
    
    [SVProgressHUD showSuccessWithStatus:@"更新成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) doBack
{
    self.entity = [Tool getMyEntity];
    [super doBack];
}

- ( void ) clickHead : (UITapGestureRecognizer *)tap
{
    sheetPhoto = [[UIActionSheet alloc] initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"使用手机拍照", nil];
    [sheetPhoto showInView:self.view];
}

- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有摄像头
    if( ![UIImagePickerController isSourceTypeAvailable:sourceType] )
    {
        [SVProgressHUD showErrorWithStatus:@"设备没有摄像头"];
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}

- ( void ) localPhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}

#pragma mark - UIActionSheetDelegate
- ( void ) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( actionSheet == sheetPhoto )
    {
        if( buttonIndex == sheetPhoto.destructiveButtonIndex )
        {
            [self localPhoto];
        }
        else if( buttonIndex == sheetPhoto.firstOtherButtonIndex )
        {
            [self takePhoto];
        }
    }
}

#pragma mark UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.hasChangeHead = YES;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.headImageData = UIImageJPEGRepresentation( [Tool scaleImage:image toScale:CGSizeMake( 400, 400 )], imageQuality );
    [headImageView setImage:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
@end
