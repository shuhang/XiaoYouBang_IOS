//
//  MyDatabase.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/7.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "MyDatabase.h"

@implementation MyDatabase
createSingleton( MyDatabase )

- ( void ) openDatabase
{
    NSString * path = [DOCMENT_PATH stringByAppendingPathComponent:@"user.sqlite"];
    database = [FMDatabase databaseWithPath:path];
}

- ( void ) closeDatabse
{
    [database close];
}

- ( FMDatabase * ) getDatabase
{
    return database;
}

@end
