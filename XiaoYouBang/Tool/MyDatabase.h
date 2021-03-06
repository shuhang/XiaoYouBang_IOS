//
//  MyDatabase.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/7.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface MyDatabase : NSObject
{
    FMDatabase * database;
}

+ ( instancetype ) shareInstance;

- ( void ) openDatabase;
- ( void ) closeDatabse;
- ( FMDatabase * ) getDatabase;

@end
