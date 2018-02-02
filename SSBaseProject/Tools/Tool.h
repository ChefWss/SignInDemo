//
//  Tool.h
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

+ (Tool *)shareTool;

//检测替换NSNull数据
+ (NSString *)replaceNull:(id)mes;

//json字符串转常规数据
+ (id)contentWithJsonString:(NSString *)jsonString;

//常规数据转json字符串
+ (NSString*)NSStringJson:(id)content;

//检测字符串中是否有空字符
+ (NSString *)judgeSpace:(NSString *)msg;

//tableView的fresh消除
+ (void)endRefresh:(UITableView *)tabelView;

//16进制色值转换
+ (UIColor *)colorWithHexString:(NSString *)hexString;

//获取当前版本号
+ (NSString *)getCurrentVersion;

//错误提示
+ (void)ShowMessage:(NSString *)msg Lasttime:(CGFloat)time;

//label高度自适应
+ (CGRect)getHetght:(NSString *)str width:(CGFloat)width font:(CGFloat)font;

//label便捷创建
+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment;

//MD5加密
+ (NSString *)md5SercetWithText:(NSString *)inPutText;

#pragma mark - 正则判断
//判断是否邮件
+ (BOOL)isValidateEmail:(NSString *)email;

//判断是否电话号
+ (BOOL)validatePhone:(NSString *)phone;

//判断是否身份证号
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo;

//判断是否银行卡号
+ (BOOL)checkBankCardNo:(NSString*)cardNo;

+(UIAlertController *)showAlertTitle:(NSString *)title btnMsg:(NSString *)msg;

+ (NSString *)getCurrentTime;
+ (NSString *)getCurrentMinuteTime;
+ (NSString *)getTodayDate;


@end



@interface UIView (Tool)

//获取view所在的控制器
- (UIViewController*)parentController;
- (void)kSetCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;

@end



@interface UIViewController (Tool)

//错误提示
- (void)showErrorMessage:(NSString*)message;

@end

