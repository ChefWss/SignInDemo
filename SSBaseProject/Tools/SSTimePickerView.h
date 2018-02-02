//
//  SSTimePickerView.h
//  SSBaseProject
//
//  Created by 王少帅 on 2018/2/2.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  remakeTimeDelgate<NSObject>

- (void)remakeTime:(NSString *)newTime withButtonIndex:(NSInteger)btnIndex;

@end

typedef NS_ENUM(NSInteger, ClickedInBtnIndex) {
    time1Button,
    time2Button
};

@interface SSTimePickerView : UIView

@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, assign) ClickedInBtnIndex btnIndex;
@property(nonatomic, weak) id<remakeTimeDelgate> delegate;

@end
