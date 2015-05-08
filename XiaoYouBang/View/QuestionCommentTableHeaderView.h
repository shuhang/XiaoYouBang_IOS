//
//  QuestionCommentTableHeaderView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCommentTableHeaderView : UIView
{
    UILabel * labelTitle;
    UILabel * labelCount;
}

- ( id ) initWithFrame:(CGRect)frame title : ( NSString * ) title value : ( NSString * ) value;
- ( void ) updateHeader : ( NSString * ) value;

@end
