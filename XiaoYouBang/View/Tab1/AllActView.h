//
//  AllActView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/20.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionEntity.h"

@protocol AllActViewDelegate <NSObject>

- ( void ) loadActInfoSuccess : ( QuestionEntity * ) entity;

@end


@interface AllActView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( strong, nonatomic ) NSMutableArray * actArray;
@property( nonatomic, strong ) QuestionEntity * selectedEntity;
@property( nonatomic, assign ) int selectedIndex;

@property( nonatomic, weak ) id< AllActViewDelegate > delegate;

- ( void ) startRefresh;
- ( void ) reloadTable;
- ( void ) updateSelectCell;

@end
