//
//  MySaveView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerEntity.h"
#import "QuestionEntity.h"

@protocol MySaveViewDelegate <NSObject>

- ( void ) clickAnswer_save : ( AnswerEntity * ) entity;
- ( void ) loadQuestionSuccess_save : ( QuestionEntity * ) entity;

@end

@interface MySaveView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( strong, nonatomic ) NSMutableArray * answerArray;
@property( nonatomic, strong ) AnswerEntity * selectedEntity;
@property( nonatomic, assign ) int selectedIndex;
@property( nonatomic, weak ) id< MySaveViewDelegate > delegate;

- ( void ) startRefresh;
- ( void ) reloadTable;
- ( void ) updateSelectCell;

@end