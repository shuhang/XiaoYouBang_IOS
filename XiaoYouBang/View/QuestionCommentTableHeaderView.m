//
//  QuestionCommentTableHeaderView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/30.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "QuestionCommentTableHeaderView.h"
#import "Tool.h"

@implementation QuestionCommentTableHeaderView

- ( id ) initWithFrame:(CGRect)frame title : ( NSString * ) title value : ( NSString * ) value
{
    self = [super initWithFrame:frame];
    if( self )
    {
        UIView * tempView = [UIView new];
        tempView.backgroundColor = Color_Light_Gray;
        [self addSubview:tempView];
        
        CGFloat height = [Tool getHeightByString:title width:Screen_Width - 20 height:60 textSize:Text_Size_Micro];
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, Screen_Width - 20, height + 20)];
        labelTitle.numberOfLines = 2;
        labelTitle.textColor = Color_Gray;
        labelTitle.font = [UIFont systemFontOfSize:Text_Size_Small];
        labelTitle.text = title;
        [tempView addSubview:labelTitle];
        tempView.frame = CGRectMake( 0, 0, Screen_Width, height + 40 );
        
        labelCount = [[UILabel alloc] initWithFrame:CGRectMake( 10, [Tool getBottom:tempView] + 10, 150, 20 )];
        labelCount.textColor = Color_Gray;
        labelCount.font = [UIFont systemFontOfSize:Text_Size_Small];
        labelCount.text = value;
        [self addSubview:labelCount];
    }
    return self;
}

- ( void ) updateHeader:( NSString * ) value
{
    labelCount.text = value;
}

@end
