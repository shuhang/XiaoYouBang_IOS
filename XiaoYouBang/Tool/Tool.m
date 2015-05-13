//
//  Tool.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "Tool.h"
#import "JSONKit.h"

@implementation Tool

+ ( CGFloat ) getHeightByString:(NSString *)value width:(NSInteger)width height:(NSInteger)height textSize:(NSInteger)textSize
{
    if( OSVersionIsAtLast7 )
    {
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:value
                                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textSize]}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, height}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        return rect.size.height;
    }
    else
    {
        CGSize maxSize = CGSizeMake( width, height );
        CGSize stringSize = [value sizeWithFont:[UIFont systemFontOfSize:textSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        return stringSize.height;
    }
}

+ ( NSMutableAttributedString * ) getModifyString:(NSString *)value
{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:value];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [value length])];
    return attributedString1;
}

+ ( NSString * ) getShowByTime:(NSString *)time
{
    NSDateFormatter * format = [NSDateFormatter new];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * timeDate = [format dateFromString:[time substringToIndex:19]];
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = - timeInterval;
    
    NSInteger temp = 0;
    if( timeInterval < 60 )
    {
        return @"刚刚";
    }
    else if( ( temp = timeInterval / 60 ) < 60 )
    {
        return [NSString stringWithFormat:@"%ld分钟前", (long)temp];
    }
    else if( ( temp = temp / 60 ) < 24 )
    {
        return [NSString stringWithFormat:@"%ld小时前", (long)temp];
    }
    else
    {
        temp = temp / 24;
        return [NSString stringWithFormat:@"%ld天前", (long)temp];
    }
}

+ ( CGFloat ) getRight : ( UIView * ) view
{
    return view.frame.origin.x + view.frame.size.width;
}

+ ( CGFloat ) getBottom : ( UIView * ) view
{
    return view.frame.origin.y + view.frame.size.height;
}

+ ( NSString * ) getShowTime:(NSString *)time
{
    if( time.length < 16 ) return @"";
    NSString * time1 = [time substringWithRange:NSMakeRange( 5, 5 )];
    NSString * time2 = [time substringWithRange:NSMakeRange( 11, 5 )];
    return [NSString stringWithFormat:@"%@ %@", time1, time2];
}

+ (UIImage *)scaleImage:(UIImage *)scaledImage toScale:(CGSize)reSize
{
    float drawW = 0.0;
    float drawH = 0.0;
    
    CGSize size_new = scaledImage.size;
    
    if (size_new.width > reSize.width) {
        drawW = (size_new.width - reSize.width)/2.0;
    }
    if (size_new.height > reSize.height) {
        drawH = (size_new.height - reSize.height)/2.0;
    }

    CGRect myImageRect = CGRectMake(drawW, drawH, reSize.width, reSize.height);
    UIImage * bigImage= scaledImage;
    scaledImage = nil;
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    UIGraphicsBeginImageContext(reSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

+ ( UserEntity * ) getMyEntity
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    UserEntity * entity = [UserEntity new];
    entity.userId = [userDefaults objectForKey:@"userId"];
    entity.name = [userDefaults objectForKey:@"name"];
    entity.sex = [[userDefaults objectForKey:@"sex"] intValue];
    entity.headUrl = [userDefaults objectForKey:@"headUrl"];
    entity.birthday = [userDefaults objectForKey:@"birthyear"];
    entity.pku = [userDefaults objectForKey:@"pku"];
    entity.nowHome = [userDefaults objectForKey:@"base"];
    entity.oldHome = [userDefaults objectForKey:@"hometown"];
    entity.qq = [userDefaults objectForKey:@"qq"];
    entity.job1 = [userDefaults objectForKey:@"company"];
    entity.job2 = [userDefaults objectForKey:@"department"];
    entity.job3 = [userDefaults objectForKey:@"job"];
    entity.intro = [userDefaults objectForKey:@"intro"];
    entity.tagArray = [userDefaults objectForKey:@"tags"];
    entity.userVersion = [[userDefaults objectForKey:@"version"] intValue];
    entity.praiseCount = [[userDefaults objectForKey:@"praisedCount"] intValue];
    entity.answerCount = [[userDefaults objectForKey:@"answerCount"] intValue];
    entity.questionCount = [[userDefaults objectForKey:@"questionCount"] intValue];
    entity.inviteName = [userDefaults objectForKey:@"inviteUserName"];
    entity.inviteHeadUrl = [userDefaults objectForKey:@"inviteUserHeadUrl"];
    entity.inviteUserId = [userDefaults objectForKey:@"inviteUserId"];
    return entity;
}

+ ( void ) loadQuestionTableEntity:(QuestionEntity *)entity item:(NSDictionary *)item
{
    entity.questionId = [NSString stringWithFormat:@"%@", item[ @"id" ]];
    entity.questionTitle = [NSString stringWithFormat:@"%@", item[ @"title" ]];
    entity.info = [NSString stringWithFormat:@"%@", item[ @"info" ]];
    entity.createTime = [NSString stringWithFormat:@"%@", item[ @"createTime" ]];
    entity.modifyTime = [NSString stringWithFormat:@"%@", item[ @"modifyTime" ]];
    entity.userId = [NSString stringWithFormat:@"%@", item[ @"userid" ]];
    entity.userName = [NSString stringWithFormat:@"%@", item[ @"name" ]];
    entity.userHeadUrl = [NSString stringWithFormat:@"%@%@", Server_Url, item[ @"headUrl" ]];
    entity.praiseCount = [item[ @"praiseCount" ] intValue];
    entity.answerCount = [item[ @"answerCount" ] intValue];
    entity.isInvisible = [item[ @"invisible"] boolValue];
    entity.type = [item[ @"questionType" ] intValue];
    
    if( item[ @"editTime" ] != nil )
    {
        entity.editTime = [NSString stringWithFormat:@"%@", item[ @"editTime" ]];
    }
    if( item[ @"changeTime" ] != nil )
    {
        entity.changeTime = [NSString stringWithFormat:@"%@", item[ @"changeTime" ]];
    }
    if( item[ @"totalJoined" ] != nil )
    {
        entity.joinCount = [item[ @"totalJoined" ] intValue];
    }
    entity.allCommentCount = [item[ @"totalComment" ] intValue];
    entity.questionCommentCount = [item[ @"commentCount" ] intValue];
    if( item[ @"hasImage" ] != nil )
    {
        entity.hasImage = [item[ @"hasImage" ] boolValue];
    }
    
    entity.myInviteArray = [NSMutableArray array];
    NSArray * array1 = item[ @"invitingList" ];
    for( NSDictionary * temp in array1 )
    {
        InviteEntity * invite = [InviteEntity new];
        invite.name = [NSString stringWithFormat:@"%@", temp[ @"name" ]];
        [entity.myInviteArray addObject:invite];
    }
    
    entity.inviteMeArray = [NSMutableArray array];
    NSArray * array2 = item[ @"inviterList" ];
    for( NSDictionary * temp in array2 )
    {
        InviteEntity * invite = [InviteEntity new];
        invite.name = [NSString stringWithFormat:@"%@", temp[ @"name" ]];
        [entity.inviteMeArray addObject:invite];
    }
}

+ ( void ) loadQuestionInfoEntity:(QuestionEntity *)entity item:(NSDictionary *)item
{
    entity.questionId = [NSString stringWithFormat:@"%@", item[ @"id" ]];
    entity.questionTitle = [NSString stringWithFormat:@"%@", item[ @"title" ]];
    entity.info = [NSString stringWithFormat:@"%@", item[ @"info" ]];
    entity.createTime = [NSString stringWithFormat:@"%@", item[ @"createTime" ]];
    entity.modifyTime = [NSString stringWithFormat:@"%@", item[ @"modifyTime" ]];
    entity.userId = [NSString stringWithFormat:@"%@", item[ @"userid" ]];
    entity.userName = [NSString stringWithFormat:@"%@", item[ @"name" ]];
    entity.userHeadUrl = [NSString stringWithFormat:@"%@%@", Server_Url, item[ @"headUrl" ]];
    entity.praiseCount = [item[ @"praiseCount" ] intValue];
    entity.answerCount = [item[ @"answerCount" ] intValue];
    entity.isInvisible = [item[ @"invisible"] boolValue];
    entity.type = [item[ @"questionType" ] intValue];
    entity.updateTime = [NSString stringWithFormat:@"%@", item[ @"updateTime" ]];
    entity.hasAnswered = [item[ @"answered" ] boolValue];
    entity.company = [NSString stringWithFormat:@"%@", item[ @"company" ]];
    entity.pku = [NSString stringWithFormat:@"%@", item[ @"pku" ]];
    entity.sex = [item[ @"sex" ] intValue];
    entity.job = [NSString stringWithFormat:@"%@", item[ @"job" ]];
    entity.hasPraised = [item[ @"praised" ] boolValue];
    
    entity.praiseArray = [NSMutableArray array];
    NSArray * array = item[ @"praiseUserList" ];
    for( NSString * temp in array )
    {
        [entity.praiseArray addObject:temp];
    }
    
    entity.imageArray = item[ @"images" ];
    
    if( item[ @"editTime" ] != nil )
    {
        entity.editTime = [NSString stringWithFormat:@"%@", item[ @"editTime" ]];
    }
    if( item[ @"changeTime" ] != nil )
    {
        entity.changeTime = [NSString stringWithFormat:@"%@", item[ @"changeTime" ]];
    }
    if( item[ @"totalJoined" ] != nil )
    {
        entity.joinCount = [item[ @"totalJoined" ] intValue];
    }
    entity.allCommentCount = [item[ @"totalComment" ] intValue];
    entity.questionCommentCount = [item[ @"commentCount" ] intValue];
    if( item[ @"hasImage" ] != nil )
    {
        entity.hasImage = [item[ @"hasImage" ] boolValue];
    }
    
    NSMutableArray * answerArray = [NSMutableArray array];
    for( NSDictionary * answer in item[ @"answers" ] )
    {
        AnswerEntity * answerEntity = [AnswerEntity new];
        [self loadAnswerInfoEntity:answerEntity item:answer];
        answerEntity.questionTitle = entity.questionTitle;
        [answerArray addObject:answerEntity];
    }
    entity.answerArray = answerArray;
    
    NSMutableArray * commentArray = [NSMutableArray array];
    for( NSDictionary * comment in item[ @"comments" ] )
    {
        CommentEntity * commentEntity = [CommentEntity new];
        [self loadCommentInfoEntity:commentEntity item:comment];
        [commentArray addObject:commentEntity];
    }
    entity.commentArray = commentArray;
    
    NSMutableArray * myInviteArray = [NSMutableArray array];
    for( NSDictionary * invite in item[ @"invitingList" ] )
    {
        InviteEntity * inviteEntity = [InviteEntity new];
        [self loadInviteInfoEntity:inviteEntity item:invite];
        [myInviteArray addObject:inviteEntity];
    }
    entity.myInviteArray = myInviteArray;
    
    NSMutableArray * inviteMeArray = [NSMutableArray array];
    NSMutableArray * inviteNameArray = [NSMutableArray array];
    for( NSDictionary * invite in item[ @"inviterList" ] )
    {
        InviteEntity * inviteEntity = [InviteEntity new];
        [self loadInviteInfoEntity:inviteEntity item:invite];
        [inviteMeArray addObject:inviteEntity];
        [inviteNameArray addObject:inviteEntity.name];
    }
    entity.inviteMeArray = inviteMeArray;
    
    if( entity.hasAnswered )
    {
        NSDictionary * myAnswer = item[ @"myanswer" ];
        AnswerEntity * answerEntity = [AnswerEntity new];
        
        answerEntity.type = [myAnswer[ @"answerType" ] intValue];
        answerEntity.answerId = [NSString stringWithFormat:@"%@", myAnswer[ @"_id" ]];
        answerEntity.info = [NSString stringWithFormat:@"%@", myAnswer[ @"content" ]];
        answerEntity.imageArray = myAnswer[ @"images" ];
        answerEntity.type = [myAnswer[ @"answerType" ] intValue];
        answerEntity.commentCount = 0;
        answerEntity.commentArray = [NSMutableArray array];
        answerEntity.createTime = @"";
        answerEntity.modifyTime = @"";
        answerEntity.hasPraised = YES;
        answerEntity.isInvisible = NO;
        answerEntity.inviteArray = inviteNameArray;
        answerEntity.praiseCount = 0;
        answerEntity.praiseArray = [NSMutableArray array];
        answerEntity.questionerName = entity.userName;
        answerEntity.questionId = entity.questionId;
        answerEntity.questionTitle = entity.questionTitle;
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        answerEntity.company = [userDefaults objectForKey:@"company"];
        answerEntity.job = [userDefaults objectForKey:@"job"];
        answerEntity.part = [userDefaults objectForKey:@"department"];
        answerEntity.pku = [userDefaults objectForKey:@"company"];
        answerEntity.name = [userDefaults objectForKey:@"name"];
        answerEntity.userHeadUrl = [NSString stringWithFormat:@"%@%@", Server_Url, [userDefaults objectForKey:@"headUrl"]];
        answerEntity.userId = [userDefaults objectForKey:@"userId"];
        answerEntity.sex = [[userDefaults objectForKey:@"sex"] intValue];
        
        entity.myAnswer = answerEntity;
    }
}

+ ( void ) loadAnswerInfoEntity:(AnswerEntity *)entity item:(NSDictionary *)item
{
    entity.answerId = [NSString stringWithFormat:@"%@", item[ @"id" ]];
    entity.createTime = [NSString stringWithFormat:@"%@", item[ @"createTime" ]];
    entity.modifyTime = [NSString stringWithFormat:@"%@", item[ @"modifyTime" ]];
    entity.info = [NSString stringWithFormat:@"%@", item[ @"content" ]];
    entity.isInvisible = [item[ @"invisible" ] boolValue];
    entity.hasPraised = [item[ @"praised" ] boolValue];
    entity.praiseCount = [item[ @"praiseCount" ] intValue];
    entity.questionTitle = [NSString stringWithFormat:@"%@", item[ @"questionTitle" ]];
    entity.questionerName = [NSString stringWithFormat:@"%@", item[ @"questionerName" ]];
    if( item[ @"editTime" ] != nil )
    {
        entity.editTime = [NSString stringWithFormat:@"%@", item[ @"editTime" ]];
    }
    else
    {
        entity.editTime = @"";
    }
    entity.type = [item[ @"answerType" ] intValue];
    entity.imageArray = item[ @"images" ];
    entity.hasImage = [item[ @"hasImage" ] boolValue];
    entity.inviteArray = item[ @"inviteList" ];
    entity.commentCount = [item[ @"commentCount" ] intValue];
    entity.commentArray = [NSMutableArray array];
    entity.praiseArray = [NSMutableArray array];
    NSArray * array = item[ @"praiseUserList" ];
    for( NSString * temp in array )
    {
        [entity.praiseArray addObject:temp];
    }
    entity.userId = [NSString stringWithFormat:@"%@", item[ @"userid" ]];
    entity.questionId = [NSString stringWithFormat:@"%@", item[ @"questionId" ]];
    entity.userHeadUrl = [NSString stringWithFormat:@"%@%@", Server_Url, item[ @"headUrl" ]];
    entity.name = [NSString stringWithFormat:@"%@", item[ @"name" ]];
    entity.company = [NSString stringWithFormat:@"%@", item[ @"company" ]];
    entity.job = [NSString stringWithFormat:@"%@", item[ @"job" ]];
    entity.part = [NSString stringWithFormat:@"%@", item[ @"department" ]];
    entity.pku = [NSString stringWithFormat:@"%@", item[ @"pku" ]];
    entity.sex = [item[ @"sex" ] intValue];
}

+ ( void ) loadCommentInfoEntity:(CommentEntity *)entity item:(NSDictionary *)item
{
    entity.commentId = [NSString stringWithFormat:@"%@", item[ @"id" ]];
    entity.info = [NSString stringWithFormat:@"%@", item[ @"content" ]];
    entity.time = [NSString stringWithFormat:@"%@", item[ @"time" ]];
    entity.userId = [NSString stringWithFormat:@"%@", item[ @"userId" ]];
    entity.userName = [NSString stringWithFormat:@"%@", item[ @"name" ]];
    entity.userHeadUrl = [NSString stringWithFormat:@"%@%@", Server_Url, item[ @"headUrl" ]];
    if( item[ @"replyId" ] != nil )
    {
        entity.replyId = [NSString stringWithFormat:@"%@", item[ @"replyId" ]];
    }
    else
    {
        entity.replyId = @"";
    }
    if( item[ @"replyName" ] != nil )
    {
        entity.replyName = [NSString stringWithFormat:@"%@", item[ @"replyName" ]];
        entity.info = [NSString stringWithFormat:@"回复 %@：%@", entity.replyName, entity.info];
    }
    else
    {
        entity.replyName = @"";
    }
    if( item[ @"commentType" ] != nil )
    {
        entity.type = [item[ @"commentType" ] intValue];
    }
    else
    {
        entity.type = 0;
    }
}

+ ( void ) loadInviteInfoEntity:(InviteEntity *)entity item:(NSDictionary *)item
{
    entity.inviteUserId = [NSString stringWithFormat:@"%@", item[ @"userId" ]];
    entity.headUrl = [NSString stringWithFormat:@"%@%@", Server_Url, item[ @"headUrl" ]];
    entity.name = [NSString stringWithFormat:@"%@", item[ @"name" ]];
    entity.info = [NSString stringWithFormat:@"%@", item[ @"words" ]];
    entity.time = [NSString stringWithFormat:@"%@", item[ @"time" ]];
    entity.hasAnswered = [item[ @"answered" ] boolValue];
}

+ ( void ) loadUserInfoEntity:(UserEntity *)entity item:(NSDictionary *)item
{
    entity.userId = [NSString stringWithFormat:@"%@", item[ @"id" ]];
    entity.name = [NSString stringWithFormat:@"%@", item[ @"name" ]];
    entity.headUrl = [NSString stringWithFormat:@"%@%@", Server_Url, item[ @"headUrl" ]];
    entity.sex = [item[ @"sex" ] intValue];
    entity.birthday = [NSString stringWithFormat:@"%@", item[ @"birthyear" ]];
    entity.pku = [NSString stringWithFormat:@"%@", item[ @"pku" ]];
    entity.nowHome = [NSString stringWithFormat:@"%@", item[ @"base" ]];
    entity.oldHome = [NSString stringWithFormat:@"%@", item[ @"hometown" ]];
    entity.qq = [NSString stringWithFormat:@"%@", item[ @"qq" ]];
    entity.job1 = [NSString stringWithFormat:@"%@", item[ @"company" ]];
    entity.job2 = [NSString stringWithFormat:@"%@", item[ @"department" ]];
    entity.job3 = [NSString stringWithFormat:@"%@", item[ @"job" ]];
    entity.userVersion = [item[ @"version" ] intValue];
    entity.intro = [NSString stringWithFormat:@"%@", item[ @"intro" ]];
    entity.praiseCount = [item[ @"praisedCount" ] intValue];
    entity.answerCount = [item[ @"answerCount" ] intValue];
    entity.questionCount = [item[ @"questionCount" ] intValue];
    entity.tagArray = item[ @"tags" ];
    if( item[ @"invitedBy" ] != nil )
    {
        NSDictionary * invite = item[ @"invitedBy" ];
        entity.inviteUserId = [NSString stringWithFormat:@"%@", invite[ @"id" ]];
        entity.inviteName = [NSString stringWithFormat:@"%@", invite[ @"name" ]];
        entity.inviteHeadUrl = [NSString stringWithFormat:@"%@%@", Server_Url, invite[ @"headUrl" ]];
    }
    else
    {
        entity.inviteUserId = @"";
        entity.inviteName = @"";
        entity.inviteHeadUrl = @"";
    }
}

+ ( NSArray * ) loadAnswerArray:(NSArray *)data
{
    NSMutableArray * array = [NSMutableArray array];
    for( NSDictionary * item in data )
    {
        AnswerEntity * entity = [AnswerEntity new];
        
        [Tool loadAnswerInfoEntity:entity item:item];
        
        [array addObject:entity];
    }
    
    return array;
}

+ ( NSMutableArray * ) loadCommentArray:(NSArray *)data
{
    NSMutableArray * array = [NSMutableArray array];
    for( NSDictionary * item in data )
    {
        CommentEntity * entity = [CommentEntity new];
        
        [Tool loadCommentInfoEntity:entity item:item];
        
        [array addObject:entity];
    }
    
    return array;
}

+ ( NSMutableArray * ) loadMessageArray:(NSArray *)data
{
    NSMutableArray * array = [NSMutableArray array];
    for( NSDictionary * item in data )
    {
        MessageEntity * entity = [MessageEntity new];
        
        entity.headUrl = [NSString stringWithFormat:@"%@%@", Server_Url, item[ @"srcUserHeadUrl" ] ];
        entity.time = [NSString stringWithFormat:@"%@", item[ @"createTime" ]];
        NSDictionary * message = item[ @"msg" ];
        
        switch( [item[ @"type" ] intValue] )
        {
            case 1 :
            {
                entity.middleUserName = [NSString stringWithFormat:@"%@", item[ @"srcUserName" ]];
                entity.info = [NSString stringWithFormat:@"%@", message[ @"content" ]];
                entity.titleUserName = [NSString stringWithFormat:@"%@", message[ @"username" ]];
                if( message[ @"qid" ] )
                {
                    entity.type = 0;
                    entity.question = [NSString stringWithFormat:@"%@", message[ @"title" ]];
                    entity.questionId = [NSString stringWithFormat:@"%@", message[ @"qid" ]];
                }
                else
                {
                    entity.type = 1;
                    entity.answer = [NSString stringWithFormat:@"%@", message[ @"title" ]];
                    entity.answerId = [NSString stringWithFormat:@"%@", message[ @"aid" ]];
                }
                break;
            }
            case 2 :
            {
                entity.type = 2;
                entity.titleUserName = [NSString stringWithFormat:@"%@", message[ @"questionUser" ]];
                entity.middleUserName = [NSString stringWithFormat:@"%@", item[ @"srcUserName" ]];
                entity.info = [NSString stringWithFormat:@"%@", message[ @"words" ]];
                entity.question = [NSString stringWithFormat:@"%@", message[ @"title" ]];
                entity.questionId = [NSString stringWithFormat:@"%@", message[ @"qid" ]];
                break;
            }
            case 3 :
            {
                entity.type = 3;
                entity.middleUserName = [NSString stringWithFormat:@"%@", item[ @"srcUserName" ]];
                entity.info = [NSString stringWithFormat:@"%@", message[ @"message" ]];
                break;
            }
            case 4 :
            {
                entity.type = 6;
                entity.titleUserName = [NSString stringWithFormat:@"%@", message[ @"questionUser" ]];
                entity.middleUserName = [NSString stringWithFormat:@"%@", item[ @"srcUserName" ]];
                entity.info = [NSString stringWithFormat:@"%@", message[ @"words" ]];
                entity.question = [NSString stringWithFormat:@"%@", message[ @"title" ]];
                entity.questionId = [NSString stringWithFormat:@"%@", message[ @"qid" ]];
                break;
            }
            case 5 :
            {
                entity.type = 4;
                entity.info = [NSString stringWithFormat:@"%@", message[ @"content" ]];
                entity.middleUserName = [NSString stringWithFormat:@"%@", item[ @"srcUserName" ]];
                if( message[ @"user" ] )
                {
                    entity.titleUserName = [NSString stringWithFormat:@"%@", message[ @"user" ]];
                }
                else
                {
                    entity.titleUserName = @"";
                }
                break;
            }
            case 6 :
            {
                entity.type = 5;
                entity.info = [NSString stringWithFormat:@"%@", message[ @"content" ]];
                entity.titleUserName = [NSString stringWithFormat:@"%@", message[ @"from" ]];
                entity.hostHeadUrl = [NSString stringWithFormat:@"%@", message[ @"fromHeadUrl" ]];
                entity.middleUserName = [NSString stringWithFormat:@"%@", item[ @"srcUserName" ]];
                entity.userId = [NSString stringWithFormat:@"%@", item[ @"user" ]];
                break;
            }
        }
        
        [array addObject:entity];
    }
    
    return array;
}

+ ( void ) getUserInfoById:(NSString *)userId token:(NSString *)token success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock
{
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    [request setValue:token forKey:@"token"];
    NSString * url = [NSString stringWithFormat:@"api/user/%@", userId];
    [[NetWork shareInstance] httpRequestWithGet:url params:request success:^(NSDictionary * result)
    {
        successBlock( result );
    }
    error:^(NSError * error)
    {
        errorBlock( error );
    }];
}

+ ( NSString * ) getPkuShortByLong:(NSString *)pku
{
    NSArray * arrayLong = [self getPkyArrayLong];
    return [[self getPkuArrayShort] objectAtIndex:[arrayLong indexOfObject:pku]];
}

+ ( NSString * ) getPkuLongByShort : ( NSString * ) pku
{
    NSArray * arrayShort = [self getPkuArrayShort];
    return [[self getPkyArrayLong] objectAtIndex:[arrayShort indexOfObject:pku]];
}

+ ( BOOL ) judgeIsMe:(NSString *)userId
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if( [userId isEqualToString:[userDefaults objectForKey:@"userId" ]] )
    {
        return YES;
    }
    return NO;
}

+ ( NSInteger ) nameSort:(UserEntity *)user1 user2:(UserEntity *)user2 context:(void *)context
{
    return [user1.name localizedCompare:user2.name];
}

+ ( NSArray * ) getPkuArrayShort
{
    return @[
              @"国际数学",
              @"城市规划",
              @"城市环境",
              @"地球空间",
              @"对外汉语",
              @"法学",
              @"分子医学",
              @"歌剧研究",
              @"工学",
              @"光华",
              @"国际法学",
              @"国际关系",
              @"国发院",
              @"核科学技术",
              @"化学生物",
              @"化学",
              @"环境工程",
              @"环境能源",
              @"汇丰商学",
              @"计科所",
              @"建筑景观",
              @"教育",
              @"经济",
              @"考古",
              @"科维理天文",
              @"历史",
              @"马克思主义",
              @"前沿交叉",
              @"人口所",
              @"人文社科",
              @"软件微电子",
              @"社会",
              @"生命科学",
              @"数学",
              @"体育教研",
              @"外语",
              @"物理",
              @"先进技术",
              @"心理",
              @"新材料",
              @"新闻传播",
              @"信息工程",
              @"信息管理",
              @"信息科学",
              @"医学部",
              @"艺术",
              @"元培",
              @"哲学",
              @"政府管理",
              @"社科调查",
              @"中文"
            ];
}

+ ( NSArray * ) getPkyArrayLong
{
    return @[
             @"北京国际数学研究中心",
             @"城市规划与设计学院",
             @"城市与环境学院",
             @"地球与空间科学学院",
             @"对外汉语教育学院",
             @"法学院",
             @"分子医学研究所",
             @"歌剧研究院",
             @"工学院",
             @"光华管理学院",
             @"国际法学院",
             @"国际关系学院",
             @"国家发展研究院/CCER",
             @"核科学与技术研究院",
             @"化学生物学与生物技术学院",
             @"化学与分子工程学院",
             @"环境科学与工程学院",
             @"环境与能源学院",
             @"汇丰商学院",
             @"计算机科学技术研究所",
             @"建筑与景观设计学院",
             @"教育学院",
             @"经济学院",
             @"考古文博学院",
             @"科维理天文研究所",
             @"历史学系",
             @"马克思主义学院",
             @"前沿交叉学科研究院",
             @"人口研究所",
             @"人文社会科学学院",
             @"软件与微电子学院",
             @"社会学系",
             @"生命科学学院",
             @"数学科学学院",
             @"体育教研部",
             @"外国语学院",
             @"物理学院",
             @"先进技术研究院",
             @"心理学系",
             @"新材料学院",
             @"新闻与传播学院",
             @"信息工程学院",
             @"信息管理系",
             @"信息科学技术学院",
             @"医学部",
             @"艺术学院",
             @"元培学院",
             @"哲学系",
             @"政府管理学院",
             @"中国社会科学调查中心",
             @"中国语言文学系"
            ];
}

@end
