//
//  MyMessageView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageEntity.h"

@protocol MyMessageViewDelegate <NSObject>

- ( void ) clickMessage : ( MessageEntity * ) entity;

@end

@interface MyMessageView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) NSMutableArray * messageArray;
@property( nonatomic, weak ) id< MyMessageViewDelegate > delegate;

@end
