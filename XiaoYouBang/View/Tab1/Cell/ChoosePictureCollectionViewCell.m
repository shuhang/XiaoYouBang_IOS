//
//  ChoosePictureCollectionViewCell.m
//  XiaoYouBang
//
//  Created by shuhang on 15/5/18.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "ChoosePictureCollectionViewCell.h"
#import "Tool.h"

@implementation ChoosePictureCollectionViewCell

- ( id ) initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:imageView];
        
        labelSize = [[UILabel alloc] initWithFrame:CGRectMake( frame.size.width - 50, frame.size.height - 15, 45, 10 )];
        labelSize.textAlignment = NSTextAlignmentRight;
        labelSize.font = [UIFont systemFontOfSize:Text_Size_Micro];
        labelSize.textColor = [UIColor whiteColor];
        [self addSubview:labelSize];
    }
    return self;
}

- ( void ) updateCell
{
    if( [self.imageUrl isEqualToString:@""] )
    {
        [imageView setImage:[UIImage imageNamed:@"add_picture"]];
        labelSize.hidden = YES;
    }
    else
    {
        [imageView setImage:[UIImage imageWithContentsOfFile:self.imageUrl]];
        labelSize.hidden = NO;
        labelSize.text = [NSString stringWithFormat:@"%dk", [Tool fileSizeAtPath:self.imageUrl]];
    }
}

@end
