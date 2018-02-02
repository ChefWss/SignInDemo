//
//  MonthDetailTableCell.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/31.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "MonthDetailTableCell.h"

@interface MonthDetailTableCell()

@property(nonatomic, strong) UILabel *dayLabel;

@end

@implementation MonthDetailTableCell

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
            make.width.equalTo(WIDTH - kPERCENT(50));
        }];
        
        self.dayLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.dayLabel];
        self.dayLabel.font = FONT_RATIO(16);
        self.dayLabel.textColor = kAppOrangeColor;
        [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(kPERCENT(25));
        }];
        
    }
    return self;
}

- (void)createLabelWithIndex:(NSInteger)row {
    self.dayLabel.text = [NSString stringWithFormat:@"%ld号", row + 1];
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
