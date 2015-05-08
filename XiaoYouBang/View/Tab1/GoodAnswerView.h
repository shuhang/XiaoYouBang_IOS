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

@protocol GoodAnswerViewDelegate <NSObject>

- ( void ) clickAnswer : ( AnswerEntity * ) entity;
- ( void ) loadQuestionSuccess : ( QuestionEntity * ) entity;

@end

@interface GoodAnswerView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( strong, nonatomic ) NSMutableArray * answerArray;
@property( nonatomic, strong ) AnswerEntity * selectedEntity;
@property( nonatomic, assign ) int selectedIndex;
@property( nonatomic, weak ) id< GoodAnswerViewDelegate > delegate;

- ( void ) startRefresh;
- ( void ) reloadTable;
- ( void ) updateSelectCell;

@end
