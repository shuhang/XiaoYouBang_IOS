//
//  AnswerTableViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/12.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "BaseViewController.h"
#import "AnswerEntity.h"

@interface AnswerTableViewController : BaseViewController

@property( strong, nonatomic ) NSMutableArray * answerArray;
@property( nonatomic, strong ) AnswerEntity * selectedEntity;
@property( nonatomic, assign ) int selectedIndex;
@property( nonatomic, strong ) NSString * userName;
@property( nonatomic, strong ) NSString * userId;
@property( nonatomic, assign ) int answerCount;

@end
