//
//  FriendTableView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@protocol FriendTableViewDelegate <NSObject>

- ( void ) clickItemAt : ( UserEntity * ) entity;
- ( void ) clickMe;

@end

@interface FriendTableView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( strong, nonatomic ) NSMutableArray * userArray;
@property( nonatomic, strong ) UserEntity * selectedEntity;
@property( nonatomic, assign ) int selectedIndex;
@property( nonatomic, weak ) id< FriendTableViewDelegate > delegate;

- ( void ) startRefresh;
- ( void ) reloadTable;
- ( void ) updateSelectCell;
- ( id ) initWithFrame:(CGRect)frame userArray : ( NSMutableArray * ) array;

@end
