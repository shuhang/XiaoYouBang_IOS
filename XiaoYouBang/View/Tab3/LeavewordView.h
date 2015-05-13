//
//  LeavewordView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/13.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentEntity.h"

@protocol LeavewordViewDelegate <NSObject>

- ( void ) clickCommentAtIndex : ( int ) index;
- ( void ) refreshSuccess : ( NSString * ) leaveWord;

@end

@interface LeavewordView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) NSMutableArray * commentArray;
@property( nonatomic, weak ) id< LeavewordViewDelegate > delegate;
@property( nonatomic, strong ) NSString * userId;

- ( void ) addSelfHeaderView : ( UIView * ) view;
- ( void ) addComment : ( CommentEntity * ) comment;
- ( void ) updateTable;
- ( void ) startRefresh;
- ( int ) getCommentCount;

@end
