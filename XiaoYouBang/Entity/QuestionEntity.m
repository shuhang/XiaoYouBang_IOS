//
//  QuestionEntity.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "QuestionEntity.h"

@implementation QuestionEntity

- ( id ) init
{
    if( self = [super init] )
    {
        self.changeTime = @"";
        self.editTime = @"";
        self.allCommentCount = 0;
        self.questionCommentCount = 0;
        self.joinCount = 0;
        
        self.commentArray = [NSMutableArray array];
        self.actArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.praiseArray = [NSMutableArray array];
    }
    return self;
}

@end
