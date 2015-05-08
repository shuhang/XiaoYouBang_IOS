//
//  CommentEntity.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentEntity : NSObject

@property( nonatomic, strong ) NSString * commentId;
@property( nonatomic, strong ) NSString * questionId;
@property( nonatomic, strong ) NSString * replyId;
@property( nonatomic, strong ) NSString * answerId;
@property( nonatomic, strong ) NSString * userId;
@property( nonatomic, strong ) NSString * userName;
@property( nonatomic, strong ) NSString * replyName;
@property( nonatomic, strong ) NSString * userHeadUrl;
@property( nonatomic, strong ) NSString * time;
@property( nonatomic, strong ) NSString * info;
@property( nonatomic, assign ) NSInteger type;

@end
