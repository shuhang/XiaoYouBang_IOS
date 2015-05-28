//
//  Tool.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserEntity.h"
#import "QuestionEntity.h"
#import "AnswerEntity.h"
#import "CommentEntity.h"
#import "InviteEntity.h"
#import "NetWork.h"
#import "MessageEntity.h"

@interface Tool : NSObject

+ ( BOOL ) getChangeAccountSymbol;
+ ( void ) setChangeAccountSymbol : ( BOOL ) value;

+ ( int ) fileSizeAtPath : ( NSString * ) filePath;

+ ( CGFloat ) getHeightByString : ( NSString * ) value
                          width : ( NSInteger ) width
                         height : ( NSInteger ) height
                       textSize : ( NSInteger ) textSize;

+ ( NSString * ) getShowByTime : ( NSString * ) time;
+ ( NSMutableAttributedString * ) getModifyString : ( NSString * ) value;

+ ( NSData * ) getThumbImageData : ( UIImage * ) image;
+ (UIImage *)scaleImage:(UIImage *)scaledImage toScale:(CGSize)reSize;
+ ( UIImage * )compressImageToSize : ( UIImage * ) imgSrc size : ( CGSize ) size;

+ ( UserEntity * ) getMyEntity;

+ ( void ) loadQuestionTableEntity : ( QuestionEntity * ) entity
                              item : ( NSDictionary * ) item;

+ ( void ) loadQuestionInfoEntity : ( QuestionEntity * ) entity
                             item : ( NSDictionary * ) item;

+ ( void ) loadAnswerInfoEntity : ( AnswerEntity * ) entity
                           item : ( NSDictionary * ) item;

+ ( void ) loadCommentInfoEntity : ( CommentEntity * ) entity
                           item : ( NSDictionary * ) item;

+ ( void ) loadInviteInfoEntity : ( InviteEntity * ) entity
                           item : ( NSDictionary * ) item;

+ ( void ) loadUserInfoEntity : ( UserEntity * ) entity
                           item : ( NSDictionary * ) item;

+ ( NSArray * ) loadAnswerArray : ( NSArray * ) data;
+ ( NSMutableArray * ) loadMessageArray : ( NSArray * ) data;
+ ( NSMutableArray * ) loadCommentArray : ( NSArray * ) data;

+ ( NSArray * ) getPkyArrayLong;
+ ( NSArray * ) getPkuArrayShort;
+ ( NSString * ) getPkuShortByLong : ( NSString * ) pku;
+ ( NSString * ) getPkuLongByShort : ( NSString * ) pku;

+ ( NSString * ) getShowTime : ( NSString * ) time;
+ ( CGFloat ) getRight : ( UIView * ) view;
+ ( CGFloat ) getBottom : ( UIView * ) view;

+ ( void ) getUserInfoById : ( NSString * ) userId
                      token: ( NSString * ) token
                   success : ( SuccessBlock ) successBlock
                     error : ( ErrorBlock ) errorBlock;

+ ( BOOL ) judgeIsMe : ( NSString * ) userId;

+ ( NSInteger ) nameSort : ( UserEntity * ) user1 user2 : ( UserEntity * ) user2 context : ( void * ) context;
@end
