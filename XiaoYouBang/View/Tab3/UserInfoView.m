//
//  UserInfoView.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/4.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "UserInfoView.h"
#import "UIImageView+WebCache.h"
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
    
    UILabel * labelComment;
    
    UIView * viewBottom;
    UIView * view5;
    UIView * view1;
    UIView * line2;
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
        headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead_)];
        [headImageView addGestureRecognizer:gesture1];
        
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
        birthLabel.textColor = Color_Heavy_Gray;
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
        pkuLabel.textColor = Color_Heavy_Gray;
        pkuLabel.text = [NSString stringWithFormat:@"北京大学 %@", [Tool getPkuLongByShort:self.entity.pku]];
        [scrollView addSubview:pkuLabel];
        
        jobLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, [Tool getBottom:pkuLabel] + 5, Screen_Width - 20, 20 )];
        jobLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        jobLabel.textColor = Color_Heavy_Gray;
        jobLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        jobLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.entity.job1, self.entity.job2, self.entity.job3];
        [scrollView addSubview:jobLabel];
        
        homeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, [Tool getBottom:jobLabel] + 5, Screen_Width - 20, 20 )];
        homeLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        homeLabel.textColor = Color_Heavy_Gray;
        homeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        homeLabel.text = [NSString stringWithFormat:@"现居：%@  家乡：%@", self.entity.nowHome, self.entity.oldHome];
        [scrollView addSubview:homeLabel];
        
        qqLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, [Tool getBottom:homeLabel] + 5, Screen_Width - 20, 20 )];
        qqLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        qqLabel.textColor = Color_Heavy_Gray;
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
        tagLabel.textColor = Color_Heavy_Gray;
        tagLabel.text = tags;
        tagLabel.numberOfLines = 0;
        tagLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [tagLabel sizeToFit];
        [scrollView addSubview:tagLabel];
        
        viewBottom = [[UIView alloc] initWithFrame:CGRectZero];
        [scrollView addSubview:viewBottom];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, Screen_Width, 10 )];
        line1.backgroundColor = Color_Light_Gray;
        [viewBottom addSubview:line1];
        
        view1 = [[UIView alloc] initWithFrame:CGRectZero];
        [viewBottom addSubview:view1];
        if( ![Tool judgeIsMe:self.entity.userId] )
        {
            heAnswerMeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 45, [Tool getBottom:line1] + 10, 90, 20 )];
            heAnswerMeLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
            heAnswerMeLabel.textColor = Color_Heavy_Gray;
            heAnswerMeLabel.text = [NSString stringWithFormat:@"他答过我 %d", self.entity.answerMe];
            [viewBottom addSubview:heAnswerMeLabel];
            
            meAnswerHeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 160, [Tool getBottom:line1] + 10, 90, 20 )];
            meAnswerHeLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
            meAnswerHeLabel.textColor = Color_Heavy_Gray;
            meAnswerHeLabel.text = [NSString stringWithFormat:@"我答过他 %d", self.entity.myAnswer];
            [viewBottom addSubview:meAnswerHeLabel];
            
            line2 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:meAnswerHeLabel] + 10, Screen_Width, 10 )];
            line2.backgroundColor = Color_Light_Gray;
            [viewBottom addSubview:line2];
            
            view1.frame = CGRectMake( 0, [Tool getBottom:line2], Screen_Width, 40 );
        }
        else
        {
            view1.frame = CGRectMake( 0, [Tool getBottom:line1], Screen_Width, 40 );
        }

        UILabel * view1Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view1Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view1Label1.textColor = Color_Heavy_Gray;
        view1Label1.text = @"自我介绍";
        [view1 addSubview:view1Label1];
        UILabel * view1Label2 = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 25, 10, 10, 20 )];
        view1Label2.font = [UIFont systemFontOfSize:Text_Size_Small];
        view1Label2.textColor = Color_Heavy_Gray;
        view1Label2.text = @">";
        view1Label2.textAlignment = NSTextAlignmentRight;
        [view1 addSubview:view1Label2];
        UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIntro_)];
        [view1 addGestureRecognizer:gesture2];
        
        UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view1], Screen_Width, 0.5 )];
        line3.backgroundColor = Color_Light_Gray;
        [viewBottom addSubview:line3];
        
        UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line3], Screen_Width, 40 )];
        [viewBottom addSubview:view2];
        UILabel * view2Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 60, 20 )];
        view2Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view2Label1.textColor = Color_Heavy_Gray;
        view2Label1.text = @"留言板";
        [view2 addSubview:view2Label1];
        labelComment = [[UILabel alloc] initWithFrame:CGRectMake( 75, 13, Screen_Width - 130, 20 )];
        labelComment.font = [UIFont systemFontOfSize:Text_Size_Micro];
        labelComment.textColor = Color_Heavy_Gray;
        labelComment.lineBreakMode = NSLineBreakByTruncatingTail;
        labelComment.numberOfLines = 1;
        [view2 addSubview:labelComment];
        leaveWordLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 55, 10, 40, 20 )];
        leaveWordLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        leaveWordLabel.textColor = Color_Heavy_Gray;
        leaveWordLabel.textAlignment = NSTextAlignmentRight;
        leaveWordLabel.text = @"0 >";
        [view2 addSubview:leaveWordLabel];
        UITapGestureRecognizer * gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeave_)];
        [view2 addGestureRecognizer:gesture3];
        
        UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view2], Screen_Width, 0.5 )];
        line4.backgroundColor = Color_Light_Gray;
        [viewBottom addSubview:line4];
        
        UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line4], Screen_Width, 40 )];
        [viewBottom addSubview:view3];
        UILabel * view3Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view3Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view3Label1.textColor = Color_Heavy_Gray;
        view3Label1.text = @"注册邀请人";
        [view3 addSubview:view3Label1];
        if( [self.entity.inviteUserId isEqualToString:@""] )
        {
            UILabel * view3Label2 = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 45, 10, 30, 20 )];
            view3Label2.font = [UIFont systemFontOfSize:Text_Size_Small];
            view3Label2.textColor = Color_Heavy_Gray;
            view3Label2.textAlignment = NSTextAlignmentRight;
            view3Label2.text = @"元老";
            [view3 addSubview:view3Label2];
        }
        else
        {
            UILabel * view3Label2 = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 15 - self.entity.inviteName.length * 13, 10, self.entity.inviteName.length * 13, 20 )];
            view3Label2.font = [UIFont systemFontOfSize:Text_Size_Small];
            view3Label2.textColor = Color_Heavy_Gray;
            view3Label2.textAlignment = NSTextAlignmentRight;
            view3Label2.text = self.entity.inviteName;
            [view3 addSubview:view3Label2];
            
            UIImageView * inviteHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake( Screen_Width - 40 - self.entity.inviteName.length * 13, 10, 20, 20)];
            [inviteHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.inviteHeadUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
            [view3 addSubview:inviteHeadImageView];
        }
        UITapGestureRecognizer * gesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickInvite_)];
        [view3 addGestureRecognizer:gesture4];
        
        UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view3], Screen_Width, 0.5 )];
        line5.backgroundColor = Color_Light_Gray;
        [viewBottom addSubview:line5];

        UIView * view4 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line5], Screen_Width, 40 )];
        [viewBottom addSubview:view4];
        UILabel * view4Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view4Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view4Label1.textColor = Color_Heavy_Gray;
        view4Label1.text = @"问过";
        [view4 addSubview:view4Label1];
        questionCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 45, 10, 30, 20 )];
        questionCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        questionCountLabel.textColor = Color_Heavy_Gray;
        questionCountLabel.textAlignment = NSTextAlignmentRight;
        [view4 addSubview:questionCountLabel];
        UITapGestureRecognizer * gesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQuestion_)];
        [view4 addGestureRecognizer:gesture5];
        
        UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view4], Screen_Width, 0.5 )];
        line6.backgroundColor = Color_Light_Gray;
        [viewBottom addSubview:line6];
        
        view5 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:line6], Screen_Width, 40 )];
        [viewBottom addSubview:view5];
        UILabel * view5Label1 = [[UILabel alloc] initWithFrame:CGRectMake( 15, 10, 90, 20 )];
        view5Label1.font = [UIFont systemFontOfSize:Text_Size_Small];
        view5Label1.textColor = Color_Heavy_Gray;
        view5Label1.text = @"答过";
        [view5 addSubview:view5Label1];
        answerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake( Screen_Width - 45, 10, 30, 20 )];
        answerCountLabel.font = [UIFont systemFontOfSize:Text_Size_Small];
        answerCountLabel.textColor = Color_Heavy_Gray;
        answerCountLabel.textAlignment = NSTextAlignmentRight;
        [view5 addSubview:answerCountLabel];
        UITapGestureRecognizer * gesture6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAnswer_)];
        [view5 addGestureRecognizer:gesture6];
        
        questionCountLabel.text = [NSString stringWithFormat:@"%d >", self.entity.questionCount];
        answerCountLabel.text = [NSString stringWithFormat:@"%d >", self.entity.answerCount];
        
        UIView * line7 = [[UIView alloc] initWithFrame:CGRectMake( 0, [Tool getBottom:view5], Screen_Width, 0.5 )];
        line7.backgroundColor = Color_Light_Gray;
        [viewBottom addSubview:line7];
        
        viewBottom.frame = CGRectMake( 0, [Tool getBottom:tagLabel] + 10, Screen_Width, [Tool getBottom:line7] + 10 );
        scrollView.contentSize = CGSizeMake( Screen_Width, [Tool getBottom:viewBottom] - 40 );
    }
    return self;
}

- ( void ) updateInfo
{
    jobLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.entity.job1, self.entity.job2, self.entity.job3];
    homeLabel.text = [NSString stringWithFormat:@"现居：%@  家乡：%@", self.entity.nowHome, self.entity.oldHome];
    qqLabel.text = [NSString stringWithFormat:@"电邮/QQ/微信：%@", self.entity.qq];
    praiseCountLabel.text = [NSString stringWithFormat:@"获赞%d", self.entity.praiseCount];
    if( ![Tool judgeIsMe:self.entity.userId] )
    {
        heAnswerMeLabel.text = [NSString stringWithFormat:@"他答过我 %d", self.entity.answerMe];
        meAnswerHeLabel.text = [NSString stringWithFormat:@"我答过他 %d", self.entity.myAnswer];
    }
    questionCountLabel.text = [NSString stringWithFormat:@"%d >", self.entity.questionCount];
    answerCountLabel.text = [NSString stringWithFormat:@"%d >", self.entity.answerCount];
    NSMutableString * tags = [NSMutableString string];
    for( NSString * item in self.entity.tagArray )
    {
        if( item && ![item isEqualToString:@"" ] )
        {
            [tags appendString:[NSString stringWithFormat:@"[%@]  ", item]];
        }
    }
    tagLabel.text = tags;
    [tagLabel sizeToFit];
    
    viewBottom.frame = CGRectMake( 0, [Tool getBottom:tagLabel] + 10, Screen_Width, [Tool getBottom:view5] + 10 );
    scrollView.contentSize = CGSizeMake( Screen_Width, [Tool getBottom:viewBottom] - 40 );
}

- ( void ) updateLeaveword:(NSString *)value count:(int)count
{
    leaveWordLabel.text = [NSString stringWithFormat:@"%d >", count];
    labelComment.text = value;
}

- ( void ) refreshUserComments
{
    dispatch_async
    (
        dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^
        {
            NSMutableDictionary * request = [NSMutableDictionary dictionary];
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [request setValue:[userDefaults objectForKey:@"token"] forKey:@"token"];
            [request setValue:@"" forKey:@"after"];
            
            NSString * url = [NSString stringWithFormat:@"api/user/%@/comments", self.entity.userId];
            [[NetWork shareInstance] httpRequestWithPostPut:url params:request method:@"POST" success:^(NSDictionary * result)
             {
                 int code = [result[ @"result"] intValue];
                 if( code == 4000 )
                 {
                     NSArray * array = result[ @"comments" ];
                     
                     dispatch_async
                     (
                          dispatch_get_main_queue(), ^
                          {
                              leaveWordLabel.text = [NSString stringWithFormat:@"%d >", ( int )array.count];
                              if( array.count > 0 )
                              {
                                  NSDictionary * item = [array objectAtIndex:0];
                                  labelComment.text = [NSString stringWithFormat:@"%@：%@", item[ @"name" ], item[ @"content" ]];
                              }
                          }
                     );
                 }
             }
             error:^(NSError * error)
             {
                 NSLog( @"%@", error );
             }];
        }
     );
}

- ( void ) clickHead_
{
    if( [self.delegate respondsToSelector:@selector(clickHeadImage)] )
    {
        [self.delegate clickHeadImage];
    }
}

- ( void ) clickIntro_
{
    if( [self.delegate respondsToSelector:@selector(clickIntro)] )
    {
        [self.delegate clickIntro];
    }
}

- ( void ) clickLeave_
{
    if( [self.delegate respondsToSelector:@selector(clickLeaveWord)] )
    {
        [self.delegate clickLeaveWord];
    }
}

- ( void ) clickInvite_
{
    if( [self.delegate respondsToSelector:@selector(clickInvite)] )
    {
        [self.delegate clickInvite];
    }
}

- ( void ) clickQuestion_
{
    if( [self.delegate respondsToSelector:@selector(clickQuestion)] )
    {
        [self.delegate clickQuestion];
    }
}

- ( void ) clickAnswer_
{
    if( [self.delegate respondsToSelector:@selector(clickAnswer)] )
    {
        [self.delegate clickAnswer];
    }
}

@end
