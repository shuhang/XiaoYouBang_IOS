//
//  GoodAnswerView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/20.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerEntity.h"
#import "QuestionEntity.h"

@protocol MyAnswerViewDelegate <NSObject>

- ( void ) clickAnswer_mine : ( AnswerEntity * ) entity;
- ( void ) loadQuestionSuccess_mine : ( QuestionEntity * ) entity;

@end

@interface MyAnswerView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( strong, nonatomic ) NSMutableArray * answerArray;
@property( nonatomic, strong ) AnswerEntity * selectedEntity;
@property( nonatomic, assign ) int selectedIndex;
@property( nonatomic, weak ) id< MyAnswerViewDelegate > delegate;

- ( void ) startRefresh;
- ( void ) reloadTable;
- ( void ) updateSelectCell;

@end
