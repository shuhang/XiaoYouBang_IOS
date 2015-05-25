//
//  ChoosePictureViewController.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/18.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "ChoosePictureViewController.h"
#import "QBImagePickerController.h"
#import "Tool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface ChoosePictureViewController ()
<UIAlertViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
QBImagePickerControllerDelegate>
{
    UIView * allView;
    UIView * mainView;
    NSInteger nowIndex;
    UIActionSheet * sheetPhoto;
}
@end
@implementation ChoosePictureViewController

- ( void )viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitle:@"添加照片"];
    [self setupNextButtonTitle:@"完成"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self reloadView];
}

- ( void ) reloadView
{
    [allView removeFromSuperview];
    allView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:allView];
    
    int count = ( int ) self.arrayPictures.count;
    if( count < 9 ) count ++;
    int width = ( Screen_Width - 40 ) / 3;
    for( int i = 0; i < count; i ++ )
    {
        int row = i / 3;
        int index = i % 3;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( 15 + index * ( 5 + width ), row * ( 5 + width ), width, width );
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button setTag:i];
        [allView addSubview:button];
        
        if( i == ( int )self.arrayPictures.count )
        {
            [button setBackgroundImage:[UIImage imageNamed:@"add_picture"] forState:UIControlStateNormal];
        }
        else
        {
            if( [[self.arrayPictures objectAtIndex:i] isKindOfClass:[ALAsset class]] )
            {
                [button setImage:[UIImage imageWithCGImage:[[self.arrayPictures objectAtIndex:i] thumbnail]] forState:UIControlStateNormal];
            }
            else if( [[self.arrayPictures objectAtIndex:i] isKindOfClass:[NSString class]] )
            {
                NSString * url = [NSString stringWithFormat:@"%@%@", Image_Server_Url, [self.arrayPictures objectAtIndex:i]];
                [button sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"picture"]];
            }
            else
            {
                [button setImage:[Tool compressImageToSize:[self.arrayPictures objectAtIndex:i] size:CGSizeMake( 400, 400 )] forState:UIControlStateNormal];
            }
        }
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int rowCount = ( count + 3 ) / 3;
    if( count == 9 ) rowCount = 3;
    allView.frame = CGRectMake( 0, 80, Screen_Width, rowCount * width + ( rowCount - 1 ) * 5 );
}

- ( void ) doNext
{
    [super doBack];
}

- ( void ) clickButton : ( id ) sender
{
    UIButton * button = ( UIButton * ) sender;
    if( [button tag] == self.arrayPictures.count )
    {
        [self addPicture];
    }
    else
    {
        [self showPicture:button];
    }
}

- ( void ) addPicture
{
    sheetPhoto = [[UIActionSheet alloc] initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"使用手机拍照", nil];
    [sheetPhoto showInView:self.view];
}

- ( void ) showPicture : ( UIButton * ) button
{
    nowIndex = button.tag;
    
    mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.frame = [UIScreen mainScreen].bounds;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake( 0, 50, Screen_Width, Screen_Height - 100 );
    if( [[self.arrayPictures objectAtIndex:button.tag] isKindOfClass:[ALAsset class]] )
    {
        imageView.image = [UIImage imageWithCGImage:[[[self.arrayPictures objectAtIndex:button.tag] defaultRepresentation] fullScreenImage]];
    }
    else if( [[self.arrayPictures objectAtIndex:button.tag] isKindOfClass:[NSString class]] )
    {
        NSString * url = [[self.arrayPictures objectAtIndex:button.tag] stringByReplacingOccurrencesOfString:@"_small" withString:@""];
        url = [NSString stringWithFormat:@"%@%@", Image_Server_Url, url];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"picture"]];
    }
    else
    {
        imageView.image = [self.arrayPictures objectAtIndex:button.tag];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [mainView addSubview:imageView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicture:)];
    [imageView addGestureRecognizer:gesture];
    
    UIButton * buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDelete.frame = CGRectMake( ( Screen_Width - 150 ) / 2, Screen_Height - 40, 150, 30 );
    buttonDelete.backgroundColor = Bg_Red;
    [buttonDelete setTitle:@"删除照片" forState:UIControlStateNormal];
    [buttonDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonDelete setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonDelete addTarget:self action:@selector(showDeletePicture) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:buttonDelete];
    
    mainView.clipsToBounds = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
}

- ( void ) hidePicture : (UITapGestureRecognizer *)tap
{
    if( [mainView isDescendantOfView:[UIApplication sharedApplication].keyWindow] )
    {
        [mainView removeFromSuperview];
    }
}

- ( void ) showDeletePicture
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该照片吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- ( void ) deletePicture
{
    [self.arrayPictures removeObjectAtIndex:nowIndex];
    [mainView removeFromSuperview];
    [self reloadView];
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
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}

- ( void ) localPhoto
{
    QBImagePickerController * imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9 - self.arrayPictures.count;
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
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
    [self.arrayPictures addObject:image];
    [self reloadView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UIAlertViewDelegate
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1 )
    {
        [self deletePicture];
    }
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

#pragma mark - QBImagePickerControllerDelegate
- (void)imagePickerController : ( QBImagePickerController * ) imagePickerController didSelectAssets:(NSArray *)assets
{
    [self.arrayPictures addObjectsFromArray:assets];
    [self dismissImagePickerController];
    [self reloadView];
}

@end
