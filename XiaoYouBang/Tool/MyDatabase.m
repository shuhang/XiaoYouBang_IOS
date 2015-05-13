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
    self.database = [FMDatabase databaseWithPath:path];
    if( ![self.database open] )
    {
        NSLog( @"Database open failed" );
    }
}

- ( void ) createAllTable
{
    [self createAnswerTable];
    [self createQuestionTable];
    [self createUserTable];
}

- ( void ) closeDatabase
{
    [self.database close];
}

- ( FMDatabase * ) getDatabase
{
    return self.database;
}

- ( void ) createUserTable
{
    [self.database executeUpdate:@"create table IF NOT EXISTS user(userId text PRIMARY KEY, name text, headUrl text, version int, sex int, birthday text, pku text, nowHome text, oldHome text, qq text, company text, part text, job text, tag1 text, tag2 text, tag3 text, tag4 text, tag5 text, questionCount int, answerCount int, praiseCount int, intro text, inviteUserName text, inviteHeadUrl text, inviteUserId text)"];
}

- ( void ) createQuestionTable
{
    [self.database executeUpdate:@"create table IF NOT EXISTS question(questionId text PRIMARY KEY, modifyTime text, answerModify text, updateTime text, changeTime text)"];
}

- ( void ) createAnswerTable
{
    [self.database executeUpdate:@"create table IF NOT EXISTS answer(answerId text PRIMARY KEY, modifyTime text, changeTime text)"];
}

@end
