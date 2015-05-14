//
//  CommentTableViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CommentTableViewController : BaseViewController

@property( nonatomic, strong ) NSMutableArray * commentArray;
@property( nonatomic, strong ) NSMutableArray * inviteArray;
@property( nonatomic, strong ) NSMutableArray * joinArray;
@property( nonatomic, strong ) NSString * questionTitle;
@property( nonatomic, strong ) NSString * questionId;
@property( nonatomic, assign ) int commentCount;
/**
  0 : question comment table
  1 : act comment table
  2 : act join table
  3 : answer table
 **/
@property( nonatomic, assign ) int type;
@property( nonatomic, assign ) BOOL shouldRefresh;
@property( nonatomic, assign ) BOOL isFromQuestionInfo;

@end
