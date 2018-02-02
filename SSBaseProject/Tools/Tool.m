//
//  Tool.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "Tool.h"
#import "CommonCrypto/CommonDigest.h"

@implementation Tool

+ (Tool *)shareTool {
    static dispatch_once_t onceToken;
    static Tool *instance;
    dispatch_once(&onceToken, ^{
        instance = [[Tool alloc] init];
    });
    return instance;
}

+ (NSString *)replaceNull:(id)mes {
    if ([mes isKindOfClass:[NSNull class]] || mes==nil) {
        return @"";
    }else if ([mes isKindOfClass:[NSNumber class]])
    {
        return [mes stringValue];
    }else
    {
        return mes;
    }
}

+ (id)contentWithJsonString:(NSString *)jsonString {
    if (jsonString == nil || [jsonString isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id content = [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:NSJSONReadingMutableContainers
                                                   error:&err];
    if(err) {
        return nil;
    }
    return content;
}

+ (NSString *)NSStringJson:(id)content {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)judgeSpace:(NSString *)msg {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [msg stringByTrimmingCharactersInSet:set];
    return trimedString;
}

+ (void)endRefresh:(UITableView *)tabelView {
    if ([tabelView.mj_header isRefreshing]) {
        [tabelView.mj_header endRefreshing];
    }
    if ([tabelView.mj_footer isRefreshing]) {
        [tabelView.mj_footer endRefreshing];
    }
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    // Bypass '#' character
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (NSString *)getCurrentVersion {
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+ (void)ShowMessage:(NSString *)msg Lasttime:(CGFloat)time {
    if (!msg) {
        msg = @"网络错误";
    }
    if (time == 0) {
        time = kMessageShowTime;
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha=0.2f;
    backView.layer.cornerRadius=kPERCENT(8);//画出带弧度的矩形
    [window addSubview:backView];
    
    UILabel *label=[[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:kPERCENT(16)];
    CGSize labelsize=CGSizeMake(0,30);
    label.text=msg;
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:kPERCENT(16)]};
    [backView addSubview:label];
    
    //尺寸
    CGRect rect=[msg boundingRectWithSize:labelsize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(window);
        make.centerY.equalTo(window).offset(kPERCENT(-20));
        make.height.equalTo(kPERCENT(50));
        make.width.equalTo(rect.size.width+kPERCENT(50));
    }];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.center.and.width.height.equalTo(backView);
    }];
    
    if (time == kMessageShowTime) {
        [UIView animateWithDuration:kMessageShowTime * 0.55 animations:^{
            backView.alpha = 0.75f;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMessageShowTime * 0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //view从window上消失
                [backView removeFromSuperview];
            });
        }];
    }
    else {
        [UIView animateWithDuration:time animations:^{
            backView.alpha = 0.75f;
        } completion:^(BOOL finished) {
            //view从window上消失
            [backView removeFromSuperview];
        }];
    }
}

+ (CGRect)getHetght:(NSString *)str width:(CGFloat)width font:(CGFloat)font {
    CGSize labelsize=CGSizeMake(width, 0);
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGRect rect=[str boundingRectWithSize:labelsize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame withImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = bgColor;
    label.textAlignment = textAlignment;
    return label;
}

+ (NSString *)md5SercetWithText:(NSString *)inPutText {
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

+ (BOOL)validatePhone:(NSString *)phone {
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|4[57])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 身份证识别
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo {
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

+ (BOOL)checkBankCardNo:(NSString*) cardNum {
    NSInteger len = [cardNum length];
    NSInteger sumNumOdd = 0;
    NSInteger sumNumEven = 0;
    BOOL isOdd = YES;
    
    for (NSInteger i = len - 1; i >= 0; i--) {
        
        NSInteger num = [cardNum substringWithRange:NSMakeRange(i, 1)].integerValue;
        if (isOdd) {//奇数位
            sumNumOdd += num;
        }else{//偶数位
            num = num * 2;
            if (num > 9) {
                num = num - 9;
            }
            sumNumEven += num;
        }
        isOdd = !isOdd;
    }
    return ((sumNumOdd + sumNumEven) % 10 == 0);
}

+(UIAlertController *)showAlertTitle:(NSString *)title btnMsg:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:msg style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //添加按钮
    [alertController addAction:action3];
    //显示警报控制器
//    [self presentViewController:alertController animated:YES completion:nil];
    return alertController;
}


+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
}

+ (NSString *)getCurrentMinuteTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
}

+ (NSString *)getTodayDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd号"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    return date;
}


@end



@implementation UIView (Global)

- (UIViewController *)parentController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)kSetCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.layer.masksToBounds = YES;
    if (radius != 0) {
        self.layer.cornerRadius = radius;
    }
    if (width != 0) {
        self.layer.borderWidth = width;
    }
    if (color != nil) {
        self.layer.borderColor = color.CGColor;
    }
}

@end



@implementation UIViewController (Global)

- (void)showErrorMessage:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

@end

