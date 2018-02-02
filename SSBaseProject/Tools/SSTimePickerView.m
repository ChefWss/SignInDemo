//
//  SSTimePickerView.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/2/2.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "SSTimePickerView.h"

@implementation SSTimePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
        SetViewBorder(self, kPERCENT(10), 0.1f, [UIColor clearColor]);

        
        // 初始化UIDatePicker，旋转滚动选择日期类
        self.datePicker = [[UIDatePicker alloc] initWithFrame:self.bounds];
        [self addSubview:self.datePicker];
        [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
        // 设置UIDatePicker的显示模式
        [self.datePicker setDatePickerMode:UIDatePickerModeTime];
        // 设置时区
        [self.datePicker setTimeZone:[NSTimeZone localTimeZone]];
        // 设置当前显示时间
        [self.datePicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
//        [self.datePicker setMaximumDate:[NSDate date]];
        // 当值发生改变的时候调用的方法
        [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        

    }
    return self;
}

- (void)setBtnIndex:(ClickedInBtnIndex)btnIndex {
    _btnIndex = btnIndex;
    [self.datePicker setDate:[NSDate date] animated:YES];
}

- (void)datePickerValueChanged:(UIDatePicker *)picker {
    NSDate *date = picker.date;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"]; //这里是用大写的H就显示24小时,h显示12小时制
    NSString *dateStr = [dateFormatter stringFromDate:date];
    [self.delegate remakeTime:dateStr withButtonIndex:self.btnIndex];
}

@end
