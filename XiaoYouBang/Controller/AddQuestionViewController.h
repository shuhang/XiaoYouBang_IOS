//
//  AddQuestionViewController.h
//
//
//  Created by shuhang on 15/4/28.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddQuestionViewController : BaseViewController

@property( nonatomic, strong ) NSString * questionTitle;
@property( nonatomic, strong ) NSString * info;
@property( nonatomic, strong ) NSString * questionId;
@property( nonatomic, assign ) BOOL isEdit;

@property( nonatomic, strong ) NSMutableArray * arrayPictures;
@property( nonatomic, strong ) NSMutableArray * imageArray;

@property( nonatomic, strong ) NSMutableArray * oldImageArray;
/**
  0 : question
  1 : act
 **/
@property( nonatomic, assign ) int type;

@end
