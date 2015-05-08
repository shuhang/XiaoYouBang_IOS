//
//  RegisterViewController2.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "RegisterViewController2.h"
#import "SVProgressHUD.h"
#import "Tool.h"
#import "RegisterViewController3.h"

@interface RegisterViewController2 ()
<UITextFieldDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource>
{
    UIButton * buttonHead;
    UIButton * buttonMale;
    UIButton * buttonFemale;
    UITextField * fieldName;
    UITextField * fieldBirthYear;
    UIButton * buttonPku;
    UITextField * fieldNowHome;
    UITextField * fieldOldHome;
    UITextField * fieldNet;
    
    UIScrollView * scrollView;
    UIActionSheet * sheetPhoto;
    UIPickerView * pickerView;
    
    UIView * tempView;

    int pkuIndex;
}
@end

@implementation RegisterViewController2

- ( void ) viewDidLoad
{
    [super viewDidLoad];
    
    self.sex = -1;
    self.headImageData = nil;
    self.pku = @"";
    pkuIndex = 0;
    
    [self setupTitle:@"自我介绍"];
    [self setupNextButtonTitle:@"下一步"];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height)];
    scrollView.backgroundColor = Color_Light_Gray;
    scrollView.directionalLockEnabled = YES;
    scrollView.contentSize = CGSizeMake( Screen_Width, 400 );
    [self.view addSubview:scrollView];
    
    buttonHead = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonHead.frame = CGRectMake( 120, 20, 90, 90 );
    buttonHead.backgroundColor = [UIColor whiteColor];
    [buttonHead.layer setBorderWidth:0.5];
    [buttonHead.layer setBorderColor:Color_Gray.CGColor];
    [buttonHead setTitleColor:Color_Gray forState:UIControlStateNormal];
    [buttonHead setTitle:@"我的真像" forState:UIControlStateNormal];
    buttonHead.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    [buttonHead addTarget:self action:@selector(showChooseHead) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:buttonHead];
    
    buttonMale = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMale.frame = CGRectMake( 130, buttonHead.frame.origin.y + 100, 25, 25 );
    [buttonMale setImage:[UIImage imageNamed:@"male_gray"] forState:UIControlStateNormal];
    [buttonMale addTarget:self action:@selector(chooseMale) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:buttonMale];
    
    buttonFemale = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFemale.frame = CGRectMake( 175, buttonMale.frame.origin.y, 25, 25 );
    [buttonFemale setImage:[UIImage imageNamed:@"female_gray"] forState:UIControlStateNormal];
    [buttonFemale addTarget:self action:@selector(chooseFemale) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:buttonFemale];
    
    fieldName = [[UITextField alloc] initWithFrame:CGRectMake( 20, buttonMale.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldName.placeholder = @"姓名";
    fieldName.delegate = self;
    fieldName.backgroundColor = [UIColor whiteColor];
    fieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldName setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldName];
    [fieldName setBorderStyle:UITextBorderStyleRoundedRect];
    [scrollView addSubview:fieldName];
    
    fieldBirthYear = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldName.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldBirthYear.placeholder = @"出生年份，例1980";
    fieldBirthYear.delegate = self;
    fieldBirthYear.backgroundColor = [UIColor whiteColor];
    fieldBirthYear.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldBirthYear setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [fieldBirthYear setBorderStyle:UITextBorderStyleRoundedRect];
    [self adjustTextField:fieldBirthYear];
    [scrollView addSubview:fieldBirthYear];
    
    buttonPku = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPku.frame = CGRectMake( 20, fieldBirthYear.frame.origin.y + 40, Screen_Width - 40, 35 );
    buttonPku.backgroundColor = [UIColor whiteColor];
    buttonPku.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
    [buttonPku setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonPku setTitle:@"北大所在院系" forState:UIControlStateNormal];
    buttonPku.contentEdgeInsets = UIEdgeInsetsMake( 0, 12, 0, 0 );
    buttonPku.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [buttonPku addTarget:self action:@selector(choosePku) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:buttonPku];
    
    fieldNowHome = [[UITextField alloc] initWithFrame:CGRectMake( 20, buttonPku.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldNowHome.placeholder = @"现居地，例四川省成都市";
    fieldNowHome.delegate = self;
    fieldNowHome.backgroundColor = [UIColor whiteColor];
    fieldNowHome.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldNowHome setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldNowHome setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldNowHome];
    [scrollView addSubview:fieldNowHome];
    
    fieldOldHome = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldNowHome.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldOldHome.placeholder = @"故乡，例黑龙江省哈尔滨市";
    fieldOldHome.delegate = self;
    fieldOldHome.backgroundColor = [UIColor whiteColor];
    fieldOldHome.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldOldHome setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldOldHome setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldOldHome];
    [scrollView addSubview:fieldOldHome];
    
    fieldNet = [[UITextField alloc] initWithFrame:CGRectMake( 20, fieldOldHome.frame.origin.y + 40, Screen_Width - 40, 35 )];
    fieldNet.placeholder = @"网络联系方式，电邮/QQ/微信";
    fieldNet.delegate = self;
    fieldNet.backgroundColor = [UIColor whiteColor];
    fieldNet.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldNet setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldNet setValue:Color_Gray forKeyPath:@"_placeholderLabel.textColor"];
    [self adjustTextField:fieldNet];
    [scrollView addSubview:fieldNet];
}

- ( void ) choosePku
{
    tempView = [[UIView alloc] initWithFrame:CGRectMake( 0, Screen_Height - 256, Screen_Width, 256)];
    tempView.backgroundColor = Color_Gray;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 250, 5, 60, 30 );
    button.backgroundColor = Color_Heavy_Gray;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
    [button addTarget:self action:@selector(finishChoosePku) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:button];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake( 0, 40, Screen_Width, 216)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = Color_Light_Gray;
    [pickerView selectRow:pkuIndex inComponent:0 animated:YES];
    [tempView addSubview:pickerView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:tempView];
}

- ( void ) finishChoosePku
{
    if( [tempView isDescendantOfView:[UIApplication sharedApplication].keyWindow] )
    {
        [tempView removeFromSuperview];
    }
    
    pkuIndex = [pickerView selectedRowInComponent:0];
    self.pku = [[Tool getPkyArrayLong] objectAtIndex:pkuIndex];
    [buttonPku setTitle:self.pku forState:UIControlStateNormal];
}

- ( void ) chooseMale
{
    if( self.sex != 1 )
    {
        self.sex = 1;
        [buttonMale setImage:[UIImage imageNamed:@"male_color"] forState:UIControlStateNormal];
        [buttonFemale setImage:[UIImage imageNamed:@"female_gray"] forState:UIControlStateNormal];
    }
}

- ( void ) chooseFemale
{
    if( self.sex != 0 )
    {
        self.sex = 0;
        [buttonMale setImage:[UIImage imageNamed:@"male_gray"] forState:UIControlStateNormal];
        [buttonFemale setImage:[UIImage imageNamed:@"female_color"] forState:UIControlStateNormal];
    }
}

- ( void ) showChooseHead
{
    sheetPhoto = [[UIActionSheet alloc] initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"使用手机拍照", nil];
    [sheetPhoto showInView:self.view];
}

- ( void ) doNext
{
    FORCE_CLOSE_KEYBOARD;
    
    if( self.headImageData == nil )
    {
        [SVProgressHUD showErrorWithStatus:@"请选择头像"];
        return;
    }
    
    if( self.sex == -1 )
    {
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    
    self.name = fieldName.text;
    if( self.name.length < 2 || self.name.length > 6 )
    {
        [SVProgressHUD showErrorWithStatus:@"姓名2~6个字"];
        return;
    }
    
    self.birthYear = fieldBirthYear.text;
    if( self.birthYear.length != 4 )
    {
        [SVProgressHUD showErrorWithStatus:@"生日输入不正确"];
        return;
    }
    
    if( self.pku.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请选择院系"];
        return;
    }
    
    self.nowHome = fieldNowHome.text;
    if( self.nowHome.length < 1 || self.nowHome.length > 10 )
    {
        [SVProgressHUD showErrorWithStatus:@"现居地10个字以内"];
        return;
    }
    
    self.oldHome = fieldOldHome.text;
    if( self.oldHome.length > 10 )
    {
        [SVProgressHUD showErrorWithStatus:@"故乡10个字以内"];
        return;
    }
    
    self.net = fieldNet.text;
    if( self.net.length < 1 || self.net.length > 40 )
    {
        [SVProgressHUD showErrorWithStatus:@"网络联系方式40个字以内"];
        return;
    }
    
    RegisterViewController3 * controller = [RegisterViewController3 new];
    controller.phone = self.phone;
    controller.password = self.password;
    controller.code = self.code;
    controller.key = self.key;
    controller.name = self.name;
    controller.birthYear = self.birthYear;
    controller.pku = self.pku;
    controller.nowHome = self.nowHome;
    controller.oldHome = self.oldHome;
    controller.net = self.net;
    controller.sex = self.sex;
    controller.headImageData = self.headImageData;
    [self.navigationController pushViewController:controller animated:YES];
}

- ( BOOL ) textFieldShouldReturn:(UITextField *)textField
{
    [fieldName resignFirstResponder];
    [fieldBirthYear resignFirstResponder];
    [fieldNowHome resignFirstResponder];
    [fieldOldHome resignFirstResponder];
    [fieldNet resignFirstResponder];
    return YES;
}

-(IBAction) textFieldDone:(id) sender
{
    [fieldName resignFirstResponder];
    [fieldBirthYear resignFirstResponder];
    [fieldNowHome resignFirstResponder];
    [fieldOldHome resignFirstResponder];
    [fieldNet resignFirstResponder];
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [fieldName resignFirstResponder];
    [fieldBirthYear resignFirstResponder];
    [fieldNowHome resignFirstResponder];
    [fieldOldHome resignFirstResponder];
    [fieldNet resignFirstResponder];
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
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.headImageData = UIImageJPEGRepresentation( image, imageQuality );
    [buttonHead setTitle:@"" forState:UIControlStateNormal];
    [buttonHead setImage:image forState:UIControlStateNormal];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[Tool getPkyArrayLong] count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[Tool getPkyArrayLong] objectAtIndex:row];
}

@end
