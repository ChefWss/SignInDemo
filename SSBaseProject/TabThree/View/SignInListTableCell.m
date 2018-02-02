//
//  SignInListTableCell.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/31.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "SignInListTableCell.h"

@interface SignInListTableCell()

@property(nonatomic, strong) UILabel *dayLabel;
@property(nonatomic, strong) UILabel *time1Label;
@property(nonatomic, strong) UILabel *time2Label;

@end

@implementation SignInListTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] init];
        [self.contentView addSubview:line];
        line.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.bottom.equalTo(self.contentView);
            make.height.equalTo(0.28);
            make.width.equalTo(WIDTH * 0.9);
        }];
        
        self.dayLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.dayLabel];
        self.dayLabel.font = FONT_RATIO(16);
        self.dayLabel.textColor = kAppOrangeColor;
        self.dayLabel.textAlignment = 1;
        [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(kPERCENT(20));
            make.width.equalTo(WIDTH * 0.3);
        }];
        
        self.time1Label = [[UILabel alloc] init];
        [self.contentView addSubview:self.time1Label];
        self.time1Label.font = FONT_RATIO(16);
        self.time1Label.textColor = [UIColor grayColor];
        self.time1Label.textAlignment = 1;
        [self.time1Label makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(WIDTH * 0.3);
        }];
        
        self.time2Label = [[UILabel alloc] init];
        [self.contentView addSubview:self.time2Label];
        self.time2Label.font = FONT_RATIO(16);
        self.time2Label.textColor = [UIColor grayColor];
        self.time2Label.textAlignment = 1;
        [self.time2Label makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.contentView);
            make.left.equalTo(self.time1Label.right);
            make.width.equalTo(WIDTH * 0.3);
        }];
        
    }
    return self;
}

- (void)createLabelWithDic:(NSMutableDictionary *)dic {
    self.dayLabel.text = [dic objectForKey:@"dictDate"];
    self.time1Label.text = [dic objectForKey:@"dictTime1"];
    self.time2Label.text = [dic objectForKey:@"dictTime2"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
