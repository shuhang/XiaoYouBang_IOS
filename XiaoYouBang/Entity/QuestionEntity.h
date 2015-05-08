//
//  QuestionEntity.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerEntity.h"

@interface QuestionEntity : NSObject

@property( nonatomic, strong ) NSString * questionId;
@property( nonatomic, strong ) NSString * userId;
@property( nonatomic, strong ) NSString * userHeadUrl;
@property( nonatomic, strong ) NSString * userName;
@property( nonatomic, strong ) NSString * company;
@property( nonatomic, strong ) NSString * job;
@property( nonatomic, strong ) NSString * pku;
@property( nonatomic, strong ) NSString * createTime;
@property( nonatomic, strong ) NSString * modifyTime;
@property( nonatomic, strong ) NSString * updateTime;
@property( nonatomic, strong ) NSString * changeTime;
@property( nonatomic, strong ) NSString * editTime;
@property( nonatomic, strong ) NSString * questionTitle;
@property( nonatomic, strong ) NSString * info;
@property( nonatomic, assign ) NSInteger type;
@property( nonatomic, assign ) NSInteger sex;
@property( nonatomic, assign ) NSInteger answerCount;
@property( nonatomic, assign ) NSInteger praiseCount;
@property( nonatomic, assign ) NSInteger questionCommentCount;
@property( nonatomic, assign ) NSInteger allCommentCount;
@property( nonatomic, assign ) NSInteger joinCount;
@property( nonatomic, assign ) BOOL hasAnswered;
@property( nonatomic, assign ) BOOL isNew;
@property( nonatomic, assign ) BOOL isModified;
@property( nonatomic, assign ) BOOL isUpdated;
@property( nonatomic, assign ) BOOL isInvisible;
@property( nonatomic, assign ) BOOL hasImage;
@property( nonatomic, assign ) BOOL hasPraised;
@property( nonatomic, assign ) BOOL hasSigned;
@property( nonatomic, strong ) NSMutableArray * inviteMeArray; //InviteEntity
@property( nonatomic, strong ) NSMutableArray * myInviteArray; //InviteEntity
@property( nonatomic, strong ) NSMutableArray * answerArray;   //AnswerEntity
@property( nonatomic, strong ) NSMutableArray * commentArray;  //CommentEntity
@property( nonatomic, strong ) NSMutableArray * actArray;      //CommentEntity
@property( nonatomic, strong ) NSMutableArray * imageArray;    //NSString
@property( nonatomic, strong ) NSMutableArray * praiseArray;   //NSString
@property( nonatomic, strong ) AnswerEntity * myAnswer;

@end
