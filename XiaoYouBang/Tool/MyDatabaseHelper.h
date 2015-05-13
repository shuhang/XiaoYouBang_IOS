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

- ( void ) insertOrUpdateUsers : ( NSArray * ) userArray
                    updateTime : ( NSString * ) time
                        symbol : ( BOOL ) symbol;
- ( UserEntity * ) getUserById : ( NSString * ) userId;
- ( UserEntity * ) getUserByName : ( NSString * ) userName;
- ( NSMutableArray * ) getUserList;

- ( BOOL ) judgeQuestionExist : ( NSString * ) questionId;
- ( void ) insertQuestion : ( NSString * ) questionId
               modifyTime : ( NSString * ) modifyTime
               updateTime : ( NSString * ) updateTime
               changeTime : ( NSString * ) changeTime;

@end
