//
//  RegisterViewController3.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/22.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RegisterViewController3 : BaseViewController

@property( nonatomic, strong ) NSString * phone;
@property( nonatomic, strong ) NSString * password;
@property( nonatomic, strong ) NSString * code;
@property( nonatomic, strong ) NSString * key;
@property( nonatomic, strong ) NSString * name;
@property( nonatomic, strong ) NSString * birthYear;
@property( nonatomic, strong ) NSString * pku;
@property( nonatomic, strong ) NSString * oldHome;
@property( nonatomic, strong ) NSString * nowHome;
@property( nonatomic, strong ) NSString * net;
@property( nonatomic, assign ) int sex;
@property( nonatomic, strong ) NSData * headImageData;
@property( nonatomic, strong ) NSString * company;
@property( nonatomic, strong ) NSString * part;
@property( nonatomic, strong ) NSString * job;

@end
