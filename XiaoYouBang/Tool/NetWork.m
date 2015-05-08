//
//  NetWork.m
//  XiaoYouBang
//
//  Created by shuhang on 15/4/21.
//  Copyright (c) 2015年 shuhang. All rights reserved.
//

#import "NetWork.h"
#import "JSONKit.h"

@implementation NetWork
createSingleton( NetWork )

- ( id ) init
{
    if( self = [super init] )
    {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
        AFHTTPResponseSerializer * response = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer = response;
    }
    return self;
}

- ( void ) httpRequestWithGet:(NSString *)url
                       params:(NSDictionary *)params
                      success:(void (^)(NSDictionary *))successBlock
                        error:(void (^)(NSError *))errorBlock
{
    NSString * getUrl = [NSString stringWithFormat:@"%@%@", Server_Url, url];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    
    [manager GET:getUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if( responseObject != nil )
        {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            successBlock( dic );
        }
        else
        {
            successBlock( @{ @"result" : @"1003" } );
        }
    }
    failure:^( AFHTTPRequestOperation * operation, NSError * error )
    {
        errorBlock( error );
    }];
}

- ( void ) httpRequestWithPostPut:(NSString *)url
                           params:(NSDictionary *)params
                           method:(NSString *)method
                          success:( SuccessBlock )successBlock
                            error:( ErrorBlock )errorBlock
{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Server_Url, url]]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:method];
    
    NSMutableData * postBody = [NSMutableData data];
    [postBody appendData:[params JSONData]];
    [request setHTTPBody:postBody];
    
    AFHTTPRequestOperation * operation = [self.manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if( responseObject != nil )
        {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            successBlock( dic );
        }
        else
        {
            successBlock( @{ @"result" : @"1003" } );
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        errorBlock( error );
    }];
    
    [self.manager.operationQueue addOperation:operation];
}

- ( void ) httpRequestWithUpload:(NSString *)url
                        fileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        mimeType:(NSString *)mimeType
                         success:(SuccessBlock)successBlock
                           error:(ErrorBlock)errorBlock
{
    __block NSData * blockFileData = fileData;
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:Server_Url]];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:blockFileData name:@"head" fileName:fileName mimeType:mimeType];
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        successBlock( dic );
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog( @"%@", error );
        errorBlock( error );
    }];
}

- ( NSDictionary * ) uploadHeadImage:(NSString *)url
                  fileName:(NSString *)fileName
                  fileData:(NSData *)fileData
                  mimeType:(NSString *)mimeType
{
    NSString * BOUNDRY = @"----WebKitFormBoundaryabcdefghijklmnop";
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Server_Url, url]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSMutableString * body = [[NSMutableString alloc] init];
    [body appendString:[NSString stringWithFormat:@"--%@\r\n", BOUNDRY]];
    [body appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"head\"; filename=\"%@\"\r\n", fileName]];
    [body appendString:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType]];
    NSString * end = [NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDRY];
    
    NSMutableData * data = [NSMutableData data];
    [data appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:fileData];
    [data appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * content = [[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@", BOUNDRY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse * response = nil;
    NSError * error = [[NSError alloc] init];
    NSData * resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSString * result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingAllowFragments error:nil];
    if( [response statusCode] == 200 )
    {
        return dic;
    }
    return nil;
}

@end
