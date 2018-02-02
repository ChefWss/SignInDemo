//
//  ApiService.h
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompleteHandler)(id content, NSError *error);

@interface ApiService : NSObject

@property(copy, nonatomic) NSString *token;
@property(assign, nonatomic) BOOL Network;

+ (ApiService *)shareApiService;
- (void)clearLoginInformation;
//通用网络请求
- (void)SendRequest:(NSString *)page Content:(NSMutableDictionary *)param CompleteHandler:(CompleteHandler)completeHandler;
//登陆
- (void)LoginByNumber:(NSString *)name Password:(NSString*)password withLoginType:(NSString *)loginType CompleteHandler:(CompleteHandler)completeHandler;

@end
