//
//  AnswerEntity.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerEntity : NSObject

@property( nonatomic, strong ) NSString * answerId;
@property( nonatomic, strong ) NSString * questionId;
@property( nonatomic, strong ) NSString * userId;
@property( nonatomic, strong ) NSString * name;
@property( nonatomic, strong ) NSString * userHeadUrl;
@property( nonatomic, strong ) NSString * info;
@property( nonatomic, strong ) NSString * company;
@property( nonatomic, strong ) NSString * job;
@property( nonatomic, strong ) NSString * part;
@property( nonatomic, strong ) NSString * pku;
@property( nonatomic, strong ) NSString * createTime;
@property( nonatomic, strong ) NSString * modifyTime;
@property( nonatomic, strong ) NSString * editTime;
@property( nonatomic, strong ) NSString * questionTitle;
@property( nonatomic, strong ) NSString * questionerName;
@property( nonatomic, assign ) int type;
@property( nonatomic, assign ) int sex;
@property( nonatomic, assign ) int praiseCount;
@property( nonatomic, assign ) int commentCount;
@property( nonatomic, assign ) BOOL isInvisible;
@property( nonatomic, assign ) BOOL hasPraised;
@property( nonatomic, assign ) BOOL hasImage;
@property( nonatomic, assign ) BOOL isHasSaved;
@property( nonatomic, strong ) NSMutableArray * inviteArray; //NSString
@property( nonatomic, strong ) NSMutableArray * praiseArray; //NSString
@property( nonatomic, strong ) NSMutableArray * imageArray;  //NSString
@property( nonatomic, strong ) NSMutableArray * commentArray;  //CommentEntity

@end
