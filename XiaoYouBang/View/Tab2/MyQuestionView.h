//
//  MyQuestionView.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQuestionView : UIView<UITableViewDataSource, UITableViewDelegate>

@property( strong, nonatomic ) NSMutableArray * questionArray;

@end
