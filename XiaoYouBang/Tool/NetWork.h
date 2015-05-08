//
//  NetWork.h
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void ( ^ SuccessBlock )( NSDictionary * );
typedef void ( ^ ErrorBlock )( NSError * );

@interface NetWork : NSObject

+ ( instancetype ) shareInstance;

- ( void ) httpRequestWithGet : ( NSString * ) url
                       params : ( NSDictionary * ) params
                      success : ( void (^)( NSDictionary * ) ) successBlock
                        error : ( void (^)( NSError * ) ) errorBlock;

- ( void ) httpRequestWithPostPut : ( NSString * ) url
                           params : ( NSDictionary * ) params
                           method : ( NSString * ) method
                          success : ( void (^)( NSDictionary * ) ) successBlock
                            error : ( void (^)( NSError * ) ) errorBlock;

- ( void ) httpRequestWithUpload : ( NSString * ) url
                        fileName : ( NSString * ) fileName
                        fileData : ( NSData * ) fileData
                        mimeType : ( NSString * ) mimeType
                         success : ( SuccessBlock ) successBlock
                           error : ( ErrorBlock ) errorBlock;

- ( NSDictionary * ) uploadHeadImage : ( NSString * ) url
                  fileName : ( NSString * ) fileName
                  fileData : ( NSData * ) fileData
                  mimeType : ( NSString * ) mimeType;

@property( nonatomic, readonly ) AFHTTPRequestOperationManager * manager;

@end
