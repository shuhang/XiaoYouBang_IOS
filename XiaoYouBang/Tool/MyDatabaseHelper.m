//
//  MyDatabaseHelper.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/7.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "MyDatabaseHelper.h"
#import "MyDatabase.h"
#import "Tool.h"

@implementation MyDatabaseHelper

- ( void ) insertOrUpdateUsers : ( NSArray * ) userArray updateTime:(NSString *)time symbol:(BOOL)symbol
{
    BOOL isRollBack = NO;
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    @try
    {
        [database beginTransaction];
        for( UserEntity * entity in userArray )
        {
            NSString * query = [NSString stringWithFormat:@"replace into user(userId, name, headUrl, version, sex, birthday, pku, nowHome, oldHome, qq, company, part, job, tag1, tag2, tag3, tag4, tag5, questionCount, answerCount, praiseCount, intro, inviteUserName, inviteHeadUrl, inviteUserId) VALUES(\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")", entity.userId, entity.name, entity.headUrl, entity.userVersion,entity.sex, entity.birthday, entity.pku, entity.nowHome, entity.oldHome, entity.qq, entity.job1, entity.job2, entity.job3, [entity.tagArray objectAtIndex:0], [entity.tagArray objectAtIndex:1], [entity.tagArray objectAtIndex:2], [entity.tagArray objectAtIndex:3], [entity.tagArray objectAtIndex:4], entity.questionCount, entity.answerCount, entity.praiseCount, entity.intro, entity.inviteName, entity.inviteHeadUrl, entity.inviteUserId];
            [database executeUpdate:query];
        }
        
        if( symbol )
        {
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:time forKey:@"user_update_time"];
            [userDefaults synchronize];
        }
    }
    @catch( NSException * exception )
    {
        isRollBack = YES;
        [database rollback];
    }
    @finally
    {
        if( !isRollBack )
        {
            [database commit];
        }
    }
}

- ( UserEntity * ) getUserById:(NSString *)userId
{
    NSString * query = [NSString stringWithFormat:@"select * from user where userId=\"%@\"", userId];
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    FMResultSet * result = [database executeQuery:query];
    while( [result next] )
    {
        UserEntity * entity = [UserEntity new];
        entity.userId = userId;
        entity.name = [result stringForColumn:@"name"];
        entity.headUrl = [result stringForColumn:@"headUrl"];
        entity.userVersion = [result intForColumn:@"version"];
        entity.sex = [result intForColumn:@"sex"];
        entity.birthday = [result stringForColumn:@"birthday"];
        entity.pku = [result stringForColumn:@"pku"];
        entity.nowHome = [result stringForColumn:@"nowHome"];
        entity.oldHome = [result stringForColumn:@"oldHome"];
        entity.qq = [result stringForColumn:@"qq"];
        entity.job1 = [result stringForColumn:@"company"];
        entity.job2 = [result stringForColumn:@"part"];
        entity.job3 = [result stringForColumn:@"job"];
        entity.tagArray = [NSMutableArray arrayWithObjects:[result stringForColumn:@"tag1"], [result stringForColumn:@"tag2"], [result stringForColumn:@"tag3"], [result stringForColumn:@"tag4"], [result stringForColumn:@"tag5"], nil];
        entity.questionCount = [result intForColumn:@"questionCount"];
        entity.answerCount = [result intForColumn:@"answerCount"];
        entity.praiseCount = [result intForColumn:@"praiseCount"];
        entity.intro = [result stringForColumn:@"intro"];
        entity.inviteName = [result stringForColumn:@"inviteUserName"];
        entity.inviteHeadUrl = [result stringForColumn:@"inviteHeadUrl"];
        entity.inviteUserId = [result stringForColumn:@"inviteUserId"];
        
        return entity;
    }
    return nil;
}

- ( UserEntity * ) getUserByName:(NSString *)userName
{
    NSString * query = [NSString stringWithFormat:@"select * from user where name=\"%@\"", userName];
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    FMResultSet * result = [database executeQuery:query];
    while( [result next] )
    {
        UserEntity * entity = [UserEntity new];
        entity.userId = [result stringForColumn:@"userId"];
        entity.name = [result stringForColumn:@"name"];
        entity.headUrl = [result stringForColumn:@"headUrl"];
        
        return entity;
    }
    return nil;
}

- ( NSMutableArray * ) getUserList
{
    NSMutableArray * userArray = [NSMutableArray array];
    NSString * query = @"select * from user";
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    FMResultSet * result = [database executeQuery:query];
    while( [result next] )
    {
        if( [Tool judgeIsMe:[result stringForColumn:@"userId"]] )
        {
            continue;
        }
        UserEntity * entity = [UserEntity new];
        entity.userId = [result stringForColumn:@"userId"];
        entity.name = [result stringForColumn:@"name"];
        entity.headUrl = [result stringForColumn:@"headUrl"];
        entity.userVersion = [result intForColumn:@"version"];
        entity.sex = [result intForColumn:@"sex"];
        entity.birthday = [result stringForColumn:@"birthday"];
        entity.pku = [result stringForColumn:@"pku"];
        entity.nowHome = [result stringForColumn:@"nowHome"];
        entity.oldHome = [result stringForColumn:@"oldHome"];
        entity.qq = [result stringForColumn:@"qq"];
        entity.job1 = [result stringForColumn:@"company"];
        entity.job2 = [result stringForColumn:@"part"];
        entity.job3 = [result stringForColumn:@"job"];
        entity.tagArray = [NSMutableArray arrayWithObjects:[result stringForColumn:@"tag1"], [result stringForColumn:@"tag2"], [result stringForColumn:@"tag3"], [result stringForColumn:@"tag4"], [result stringForColumn:@"tag5"], nil];
        entity.questionCount = [result intForColumn:@"questionCount"];
        entity.answerCount = [result intForColumn:@"answerCount"];
        entity.praiseCount = [result intForColumn:@"praiseCount"];
        entity.intro = [result stringForColumn:@"intro"];
        entity.inviteName = [result stringForColumn:@"inviteUserName"];
        entity.inviteHeadUrl = [result stringForColumn:@"inviteHeadUrl"];
        entity.inviteUserId = [result stringForColumn:@"inviteUserId"];
        
        [userArray addObject:entity];
    }
    return userArray;
}

- ( BOOL ) judgeQuestionExist:(NSString *)questionId
{
    NSString * query = [NSString stringWithFormat:@"select * from question where questionId=\"%@\"", questionId];
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    FMResultSet * result = [database executeQuery:query];
    if( [result next] )
    {
        return YES;
    }
    return NO;
}

- ( void ) insertQuestion:(NSString *)questionId
               modifyTime:(NSString *)modifyTime
               updateTime:(NSString *)updateTime
               changeTime:(NSString *)changeTime
{
    FMDatabase * database = [[MyDatabase shareInstance] getDatabase];
    NSString * query = [NSString stringWithFormat:@"replace into question(questionId, modifyTime, answerModify, updateTime, changeTime) VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", questionId, modifyTime, @"", updateTime, changeTime];
    [database executeUpdate:query];
}

@end
