//
//  EditInfoViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "BaseViewController.h"
#import "UserEntity.h"

@interface EditInfoViewController : BaseViewController

@property( nonatomic, strong ) UserEntity * entity;
@property( nonatomic, assign ) BOOL hasChangeHead;
@property( nonatomic, strong ) NSData * headImageData;
@property( nonatomic, strong ) NSString * headUrl;

@end
