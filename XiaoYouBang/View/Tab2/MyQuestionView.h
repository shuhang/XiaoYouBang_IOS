//
//  MyQuestionView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionEntity.h"

@protocol MyQuestionViewDelegate <NSObject>

- ( void ) loadQuestionInfoSuccess : ( QuestionEntity * ) entity;

@end

@interface MyQuestionView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( strong, nonatomic ) NSMutableArray * questionArray;
@property( nonatomic, strong ) QuestionEntity * selectedEntity;
@property( nonatomic, assign ) int selectedIndex;

@property( nonatomic, weak ) id< MyQuestionViewDelegate > delegate;

- ( void ) startRefresh;
- ( void ) reloadTable;
- ( void ) updateSelectCell;

@end
