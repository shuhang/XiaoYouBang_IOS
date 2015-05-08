//
//  UserInfoView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "UserInfoView.h"
#import <UIImageView+WebCache.h>
#import "Tool.h"

@interface UserInfoView()
{
    UIScrollView * scrollView;
    
    UIImageView * headImageView;
    UIImageView * sexImageView;
    
    UILabel * nameLabel;
    UILabel * praiseCountLabel;
    UILabel * birthLabel;
    UILabel * pkuLabel;
    UILabel * jobLabel;
    UILabel * homeLabel;
    UILabel * qqLabel;
    UILabel * tagLabel;
    UILabel * meAnswerHeLabel;
    UILabel * heAnswerMeLabel;
    UILabel * leaveWordLabel;
    UILabel * questionCountLabel;
    UILabel * answerCountLabel;
}
@end

@implementation UserInfoView

- ( id ) initWithFrame:(CGRect)frame entity:(UserEntity *)entity
{
    if( self = [super initWithFrame:frame] )
    {
        self.entity = entity;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, Screen_Height)];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.directionalLockEnabled = YES;
        [self addSubview:scrollView];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 15, 15, 80, 80 )];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
        [scrollView addSubview:headImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 105, 15, 70, 25 )];
        nameLabel.font = [UIFont systemFontOfSize:Text_Size_Big];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.text = self.entity.name;
        [scrollView addSubview:nameLabel];
        
        praiseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 90, 15, 80, 20 )];
        praiseCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        praiseCountLabel.textColor = Text_Red;
        praiseCountLabel.textAlignment = NSTextAlignmentRight;
        praiseCountLabel.text = [NSString stringWithFormat:@"获赞%d", self.entity.praiseCount];
        [scrollView addSubview:praiseCountLabel];
        
        birthLabel = [[UILabel alloc] initWithFrame:CGRectMake( 105, 45, 80, 20 )];
        birthLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        birthLabel.textColor = Color_Gray;
        birthLabel.text = [NSString stringWithFormat:@"%@年生人", self.entity.birthday];
        [scrollView addSubview:birthLabel];
        
        sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 105, 75, 20, 20 )];
        if( self.entity.sex == 0 )
        {
            [sexImageView setImage:[UIImage imageNamed:@"female_color"]];
        }
        else
        {
            [sexImageView setImage:[UIImage imageNamed:@"male_color"]];
        }
        [scrollView addSubview:sexImageView];
        
        pkuLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, [Tool getBottom:headImageView] + 10, Screen_Width - 20, 20 )];
        pkuLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        pkuLabel.textColor = Color_Gray;
        pkuLabel.text = [NSString stringWithFormat:@"北京大学 %@", [Tool getPkuLongByShort:self.entity.pku]];
        [scrollView addSubview:pkuLabel];
        
        jobLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, [Tool getBottom:pkuLabel] + 5, Screen_Width - 20, 20 )];
        jobLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        jobLabel.textColor = Color_Gray;
        jobLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        jobLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.entity.job1, self.entity.job2, self.entity.job3];
        [scrollView addSubview:jobLabel];
        
        homeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, [Tool getBottom:jobLabel] + 5, Screen_Width - 20, 20 )];
        homeLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        homeLabel.textColor = Color_Gray;
        homeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        homeLabel.text = [NSString stringWithFormat:@"现居：%@  家乡：%@", self.entity.nowHome, self.entity.oldHome];
        [scrollView addSubview:homeLabel];
        
        qqLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, [Tool getBottom:homeLabel] + 5, Screen_Width - 20, 20 )];
        qqLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        qqLabel.textColor = Color_Gray;
        qqLabel.text = [NSString stringWithFormat:@"电邮/QQ/微信：%@", self.entity.qq];
        [scrollView addSubview:qqLabel];
        
        NSMutableString * tags = [NSMutableString string];
        for( NSString * item in self.entity.tagArray )
        {
            if( item && ![item isEqualToString:@"" ] )
            {
                [tags appendString:[NSString stringWithFormat:@"[%@]  ", item]];
            }
        }
        
        tagLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, [Tool getBottom:qqLabel] + 10, Screen_Width - 20, 0 )];
        tagLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        tagLabel.textColor = Color_Gray;
        tagLabel.text = tags;
        tagLabel.numberOfLines = 0;
        tagLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [tagLabel sizeToFit];
        [scrollView addSubview:tagLabel];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:tagLabel] + 10, Screen_Width, 10 )];
        line1.backgroundColor = Color_Light_Gray;
        [scrollView addSubview:line1];
        
        heAnswerMeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 45, [Tool getBottom:line1] + 10, 90, 20 )];
        heAnswerMeLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        heAnswerMeLabel.textColor = Color_Gray;
        heAnswerMeLabel.text = [NSString stringWithFormat:@"他答过我 %d", self.entity.answerMe];
        [scrollView addSubview:heAnswerMeLabel];
        
        meAnswerHeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 160, [Tool getBottom:line1] + 10, 90, 20 )];
        meAnswerHeLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        meAnswerHeLabel.textColor = Color_Gray;
        meAnswerHeLabel.text = [NSString stringWithFormat:@"我答过他 %d", self.entity.myAnswer];
        [scrollView addSubview:meAnswerHeLabel];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:meAnswerHeLabel] + 10, Screen_Width, 10 )];
        line2.backgroundColor = Color_Light_Gray;
        [scrollView addSubview:line2];
        
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line2], Screen_Width, 40 )];
        [scrollView addSubview:view1];
        UILabel * view1Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view1Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view1Label1.textColor = Color_Gray;
        view1Label1.text = @"自我介绍";
        [view1 addSubview:view1Label1];
        UILabel * view1Label2 = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 25, 10, 10, 20 )];
        view1Label2.font = [UIFont systemFontOfSize:Text_Size_Small];
        view1Label2.textColor = Color_Gray;
        view1Label2.text = @">";
        view1Label2.textAlignment = NSTextAlignmentRight;
        [view1 addSubview:view1Label2];
        
        UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view1], Screen_Width, 0.5 )];
        line3.backgroundColor = Color_Light_Gray;
        [scrollView addSubview:line3];
        
        UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line3], Screen_Width, 40 )];
        [scrollView addSubview:view2];
        UILabel * view2Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view2Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view2Label1.textColor = Color_Gray;
        view2Label1.text = @"留言板";
        [view2 addSubview:view2Label1];
        leaveWordLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 45, 10, 30, 20 )];
        leaveWordLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        leaveWordLabel.textColor = Color_Gray;
        leaveWordLabel.textAlignment = NSTextAlignmentRight;
        leaveWordLabel.text = @"0 >";
        [view2 addSubview:leaveWordLabel];
        
        UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view2], Screen_Width, 0.5 )];
        line4.backgroundColor = Color_Light_Gray;
        [scrollView addSubview:line4];
        
        UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line4], Screen_Width, 40 )];
        [scrollView addSubview:view3];
        UILabel * view3Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view3Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view3Label1.textColor = Color_Gray;
        view3Label1.text = @"注册邀请人";
        [view3 addSubview:view3Label1];
        if( [self.entity.inviteUserId isEqualToString:@""] )
        {
            UILabel * view3Label2 = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 45, 15, 30, 20 )];
            view3Label2.font = [UIFont systemFontOfSize:Text_Size_Small];
            view3Label2.textColor = Color_Gray;
            view3Label2.textAlignment = NSTextAlignmentRight;
            view3Label2.text = @"元老";
            [view3 addSubview:view3Label2];
        }
        else
        {
            UILabel * view3Label2 = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 15 - self.entity.inviteName.length * 13, 15, self.entity.inviteName.length * 13, 20 )];
            view3Label2.font = [UIFont systemFontOfSize:Text_Size_Small];
            view3Label2.textColor = Color_Gray;
            view3Label2.textAlignment = NSTextAlignmentRight;
            view3Label2.text = self.entity.inviteName;
            [view3 addSubview:view3Label2];
            
            UIImageView * inviteHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake( Screen_Width - 40 - self.entity.inviteName.length * 13, 10, 20, 20)];
            [inviteHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.inviteHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
            [view3 addSubview:inviteHeadImageView];
        }
        
        UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view3], Screen_Width, 0.5 )];
        line5.backgroundColor = Color_Light_Gray;
        [scrollView addSubview:line5];
        
        UIView * view4 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line5], Screen_Width, 40 )];
        [scrollView addSubview:view4];
        UILabel * view4Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view4Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view4Label1.textColor = Color_Gray;
        view4Label1.text = @"问过";
        [view4 addSubview:view4Label1];
        questionCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 45, 10, 30, 20 )];
        questionCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        questionCountLabel.textColor = Color_Gray;
        questionCountLabel.textAlignment = NSTextAlignmentRight;
        questionCountLabel.text = [NSString stringWithFormat:@"%d >", self.entity.questionCount];
        [view4 addSubview:questionCountLabel];
        
        UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view4], Screen_Width, 0.5 )];
        line6.backgroundColor = Color_Light_Gray;
        [scrollView addSubview:line6];
        
        UIView * view5 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line6], Screen_Width, 40 )];
        [scrollView addSubview:view5];
        UILabel * view5Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view5Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view5Label1.textColor = Color_Gray;
        view5Label1.text = @"答过";
        [view5 addSubview:view5Label1];
        questionCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 45, 10, 30, 20 )];
        questionCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        questionCountLabel.textColor = Color_Gray;
        questionCountLabel.textAlignment = NSTextAlignmentRight;
        questionCountLabel.text = [NSString stringWithFormat:@"%d >", self.entity.answerCount];
        [view5 addSubview:questionCountLabel];
        
        scrollView.contentSize = CGSizeMake( Screen_Width, [Tool getBottom:view5] + -40 );
    }
    return self;
}

@end
