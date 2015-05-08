//
//  MyDatabaseHelper.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/7.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "MyDatabaseHelper.h"
#import "MyDatabase.h"

@implementation MyDatabaseHelper

- ( id ) init
{
    if( self = [super init] )
    {
        [self createAnswerTable];
        [self createQuestionTable];
        [self createUserTable];
    }
    return self;
}

- ( void ) createUserTable
{
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    [database executeUpdate:@"create table IF NOT EXISTS user(userId text PRIMARY KEY,name text, headUrl text, version int, sex int, birthday text, pku text, nowHome text, oldHome text, qq text, company text, part text, job text, tag1 text, tag2 text, tag3 text, tag4 text, tag5 text, questionCount int, answerCount int, praiseCount int, intro text, inviteUserName text, inviteHeadUrl text, inviteUserId text)"];
}

- ( void ) createQuestionTable
{
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    [database executeUpdate:@"create table IF NOT EXISTS question(questionId text PRIMARY KEY, hasRead int, modifyTime text, answerModify text, updateTime text, changeTime text)"];
}

- ( void ) createAnswerTable
{
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    [database executeUpdate:@"create table IF NOT EXISTS answer(answerId text PRIMARY KEY, modifyTime text, changeTime text)"];
}

@end
