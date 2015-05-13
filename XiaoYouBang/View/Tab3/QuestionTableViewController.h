//
//  QuestionTableViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/12.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "BaseViewController.h"
#import "QuestionEntity.h"

@interface QuestionTableViewController : BaseViewController

@property( strong, nonatomic ) NSMutableArray * questionArray;
@property( nonatomic, strong ) QuestionEntity * selectedEntity;
@property( nonatomic, assign ) int selectedIndex;
@property( nonatomic, strong ) NSString * userId;
@property( nonatomic, strong ) NSString * userName;
@property( nonatomic, assign ) int questionCount;

@end
