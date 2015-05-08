//
//  CommentTableView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentTableViewDelegate <NSObject>

- ( void ) clickCommentAtIndex : ( int ) index;
- ( void ) refreshSuccess;

@end

@interface CommentTableView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) NSMutableArray * commentArray;
@property( nonatomic, assign ) int commentCount;
@property( nonatomic, weak ) id< CommentTableViewDelegate > delegate;
@property( nonatomic, assign ) int type;
@property( nonatomic, strong ) NSString * questionId;

- ( void ) addSelfHeaderView : ( UIView * ) view;
- ( void ) updateTable;
- ( void ) startRefresh;

@end
