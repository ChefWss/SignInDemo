//
//  ApiService.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "ApiService.h"
#import "AppDelegate.h"
#import "LoginVC.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface ApiService()

@property(nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation ApiService

+ (ApiService *)shareApiService {
    static dispatch_once_t onceToken;
    static ApiService *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ApiService alloc] init];
    });
    return instance;
}

- (AFHTTPSessionManager *)httpSessionManager {
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        _httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _httpSessionManager.requestSerializer.timeoutInterval=30;
//        _httpSessionManager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    return _httpSessionManager;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.token = [defaults objectForKey:@"token"];
        [defaults synchronize];
//        NSMutableDictionary *User = [defaults objectForKey:@"User"];
//        [self getUser:User];
        [self monitorNetworkState];
    }
    return self;
}

#pragma mark - 登陆
- (void)LoginByNumber:(NSString *)name Password:(NSString*)password withLoginType:(NSString *)loginType CompleteHandler:(CompleteHandler)completeHandler {
    NSString *url = [self makeURL:@"passport/login"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:name forKey:@"userName"];
    [param setObject:password forKey:@"password"];
    [self.httpSessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task,id responseObject) {
        [self doResponse:responseObject CompleteHanler:^(id content, NSError *error) {
        if(content) {
            UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
            keychainStore[@"UserName"] = name;
            keychainStore[@"Password"] = password;
            [self saveLoginInformation:content];
            completeHandler(content, nil);
        }
        else {
            completeHandler(nil,error);
        }
        }];
     } failure:^(NSURLSessionDataTask *task,NSError *error) {
         NSError *newerror;
         newerror = [NSError errorWithDomain:@"response" code:0 userInfo:@{NSLocalizedDescriptionKey:@"网络错误"}];
         completeHandler(nil, newerror);
     }];
}

#pragma mark - 保存个人信息
- (void)saveLoginInformation:(id)content {
    self.token = [content objectForKey:@"token"];
    NSDictionary *u = [content objectForKey:@"user"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *key in u.allKeys) {
        id obj = [u objectForKey:key];
        if([obj isKindOfClass:[NSNull class]]) {
            obj = @"";
        }
        [dic setObject:obj forKey:key];
    }
    [self getUser:u];
    UserDefaults_WriteObj(dic, @"User");
    UserDefaults_WriteObj(self.token, @"token");
    UserDefaults_Synchronize;
}

- (void)getUser:(NSDictionary *)apiUser {
    User *user = [User shareUser];
    user.userName = [apiUser objectForKey:@"userName"];
    user.realName = [apiUser objectForKey:@"realName"];
    user.userID = [apiUser objectForKey:@"id"];
    user.email = [apiUser objectForKey:@"email"];
    user.phoneNum = [apiUser objectForKey:@"phone"];
}

#pragma mark -清除登陆信息
- (void)clearLoginInformation{
    self.token = nil;
    UserDefaults_WriteObj(self.token, @"token");
    UserDefaults_Synchronize;
    User *user = [User shareUser];
    user.userName = nil;
    user.realName = nil;
    user.userID = nil;
    user.email = nil;
    user.phoneNum = nil;
}

#pragma mark -常规网络请求
- (void)SendRequest:(NSString *)page Content:(NSMutableDictionary *)param CompleteHandler:(CompleteHandler)completeHandler {
    if (param == nil) {
        param = [NSMutableDictionary dictionary];
    }
    NSString *url = [self makeURL:page];
    param[@"token"] = self.token;
    [self.httpSessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task,id responseObject) {
         [self doResponse:responseObject CompleteHanler:^(id content, NSError *error) {
             if(content) {
                 completeHandler(content, nil);
             }
             else {
                 completeHandler(nil, error);
             }
         }];
     } failure:^(NSURLSessionDataTask *task,NSError *error){
         NSError *newerror;
         newerror = [NSError errorWithDomain:@"response" code:0 userInfo:@{NSLocalizedDescriptionKey:@"网络错误"}];
         completeHandler(nil, newerror);
     }];
}


#pragma mark -数据解析
- (void)doResponse:(NSData *)data CompleteHanler:(CompleteHandler)completeHandler {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        if (completeHandler) {
            error=[NSError errorWithDomain:@"response" code:0 userInfo:@{NSLocalizedDescriptionKey:@"数据格式错误"}];
            completeHandler(nil, error);
        }
    }
    else {
        if ([[json objectForKey:@"code"] integerValue]==200) {
            completeHandler([json objectForKey:@"data"], nil);
        }
        else if([[json objectForKey:@"code"] integerValue]==600 || [[json objectForKey:@"code"] integerValue]==601) {
            //token失效退出登录
            [self alertShowTokenFailure];
            completeHandler(nil, nil);
        }
        else {
            error=[NSError errorWithDomain:@"response" code:[[json objectForKey:@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:[json objectForKey:@"message"]}];
            completeHandler(nil,error);
        }
    }
}

#pragma mark - token失效退出登录
- (void)alertShowTokenFailure {
    NSString *title = @"温馨提示";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"登录状态已过期,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self clearLoginInformation];
    AppDelegate *deleagte = (AppDelegate*)[UIApplication sharedApplication].delegate;
    deleagte.window.rootViewController = [[LoginVC alloc] init];
}

#pragma mark - url拼接
- (NSString *)makeURL:(NSString *)page {
    NSString *url = [NSString stringWithFormat:@"%@%@", SeverAddress, page];
    return url;
}

- (void)monitorNetworkState {
    AFNetworkReachabilityManager *manager=[AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.Network=NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //没有网络
                self.Network=NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.Network=YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.Network=YES;
                break;
            default:
                self.Network=NO;
                break;
        }
    }];
    [manager startMonitoring];
}

@end
