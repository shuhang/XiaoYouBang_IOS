//
//  MyDatabaseHelper.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/7.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

@interface MyDatabaseHelper : NSObject

- ( void ) insertUser : ( UserEntity * ) userEntity;

@end
