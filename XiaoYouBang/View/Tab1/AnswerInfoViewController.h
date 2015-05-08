//
//  AnswerInfoViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/2.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "BaseViewController.h"
#import "AnswerEntity.h"

@interface AnswerInfoViewController : BaseViewController

@property( nonatomic, strong ) AnswerEntity * entity;
@property( nonatomic, assign ) BOOL isFromQuestionInfo;

@end
