//
//  ChoosePictureCollectionViewCell.h
//  XiaoYouBang
//
//  Created by shuhang on 15/5/18.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePictureCollectionViewCell : UICollectionViewCell
{
    UIImageView * imageView;
    UILabel * labelSize;
}

@property( nonatomic, strong ) NSString * imageUrl;

- ( void ) updateCell;

@end
