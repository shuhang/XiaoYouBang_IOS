//
//  AddCommentViewController.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddCommentViewController : BaseViewController

@property( nonatomic, strong ) NSString * info;
@property( nonatomic, strong ) NSString * questionId;
@property( nonatomic, strong ) NSString * answerId;
@property( nonatomic, strong ) NSString * commentId;
@property( nonatomic, strong ) NSString * replyId;
@property( nonatomic, strong ) NSString * replyName;
@property( nonatomic, assign ) BOOL isEdit;

/**
 *  0 : question
 *  1 : answer
 *  2 : act
 *  3 : leaveword
 */
@property( nonatomic, assign ) int type;

@end
