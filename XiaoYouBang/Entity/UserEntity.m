//
//  UserEntity.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

- ( id ) init
{
    if( self = [super init] )
    {
        self.myAnswer = 0;
        self.answerMe = 0;
    }
    return self;
}

@end
