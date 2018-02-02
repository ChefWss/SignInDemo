//
//  ChangeTimeVC.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/2/1.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "ChangeTimeVC.h"
#import "SSTimePickerView.h"
#import "ZXYCircleProgress.h"

@interface ChangeTimeVC ()<remakeTimeDelgate>
{
    CGRect hidFrame;
    CGRect showFrame;
    int speed;
}

@property(nonatomic, strong) UIButton *btn1;
@property(nonatomic, strong) UIButton *btn2;
@property(nonatomic, strong) UIButton *btn;
@property(nonatomic, strong) SSTimePickerView *pickerView;

@property(nonatomic, strong) ZXYCircleProgress *circleProgress;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UIImageView *imgView;

@end

@implementation ChangeTimeVC


- (SSTimePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[SSTimePickerView alloc] initWithFrame:hidFrame];
        [self.view addSubview:_pickerView];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@-修改记录", [self.dic objectForKey:@"dictDate"]];
    
    hidFrame = CGRectMake(kPERCENT(10), HEIGHT-64, WIDTH-kPERCENT(20), kPERCENT(160));
    showFrame = CGRectMake(kPERCENT(10), HEIGHT-64-kPERCENT(165), WIDTH-kPERCENT(20), kPERCENT(160));
    speed = 0;
    
    [self createUI];
    
}

- (void)action:(NSTimer *)sender {
    speed ++;
    _circleProgress.progress = speed / 20.00;
    if (speed == 20) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)createUI {
    self.btn1 = [[UIButton alloc] init];
    SetViewBorder(self.btn1, kPERCENT(4), 0.8, kAppOrangeColor);
    self.btn1.titleLabel.font = FONT_RATIO(19);
    [self.btn1 setTitleColor:kAppOrangeColor forState:UIControlStateSelected];
    [self.btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:self.btn1];
    [self.btn1 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.centerX).offset(kPERCENT(-10));
        make.top.equalTo(self.view).offset(kPERCENT(100));
        make.height.equalTo(kPERCENT(60));
        make.width.equalTo(WIDTH * 0.4);
    }];
    [self.btn1 addTarget:self action:@selector(didClickedInButton1:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn2 = [[UIButton alloc] init];
    SetViewBorder(self.btn2, kPERCENT(4), 0.8, kAppOrangeColor);
    self.btn2.titleLabel.font = FONT_RATIO(19);
    [self.btn2 setTitleColor:kAppOrangeColor forState:UIControlStateSelected];
    [self.btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:self.btn2];
    [self.btn2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(kPERCENT(10));
        make.top.equalTo(self.view).offset(kPERCENT(100));
        make.height.equalTo(kPERCENT(60));
        make.width.equalTo(WIDTH * 0.4);
    }];
    [self.btn2 addTarget:self action:@selector(didClickedInButton2:) forControlEvents:UIControlEventTouchUpInside];

    
    
    self.circleProgress = [[ZXYCircleProgress alloc] initWithFrame:CGRectMake((WIDTH - kPERCENT(140)) * 0.50, kPERCENT(272), kPERCENT(140), kPERCENT(140)) progress:0];
    _circleProgress.progressWidth = 1.3f;
    _circleProgress.bottomColor = [UIColor grayColor];
    _circleProgress.topColor = kAppOrangeColor;
    _circleProgress.progress = 0;
    [self.view addSubview:_circleProgress];
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"更改记录" forState:UIControlStateNormal];
    _btn.titleLabel.font = FONT_RATIO(18);
    //    SetViewBorder(btn, kPERCENT(70), 1.2f, [UIColor grayColor]);
    [_btn setTitleColor:kAppOrangeColor forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(didClickedInButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    _btn.frame = CGRectMake((WIDTH - kPERCENT(140)) * 0.50, kPERCENT(270), kPERCENT(140), kPERCENT(140));
    
    [self.btn1 setTitle:[self.dic objectForKey:@"dictTime1"] forState:UIControlStateNormal];
    [self.btn2 setTitle:[self.dic objectForKey:@"dictTime2"] forState:UIControlStateNormal];

}


- (void)didClickedInButton {
    // 开始timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    [[DBObject sharedInstance] updateWithTime1:self.btn1.titleLabel.text time2:self.btn2.titleLabel.text WithDate:[self.dic objectForKey:@"dictDate"]];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_btn setTitle:@"" forState:UIControlStateNormal];
        
        self.imgView = [[UIImageView alloc] initWithImage:GetImgWithName(@"nike")];
        [self.view addSubview:self.imgView];
        self.imgView.frame = CGRectMake(0, 0, 0.01, 0.01);
        self.imgView.center = self.circleProgress.center;
        [UIView animateWithDuration:1 animations:^{
            self.imgView.frame = CGRectMake(0, 0, kPERCENT(100), kPERCENT(100));
            self.imgView.center = self.circleProgress.center;
        } completion:^(BOOL finished) {
            
        }];
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

- (void)didClickedInButton1:(UIButton *)btn1 {
    self.btn1.selected = YES;
    self.btn2.selected = NO;
    self.pickerView.btnIndex = time1Button;
    [UIView animateWithDuration:0.35 animations:^{
        self.pickerView.frame = showFrame;
    }];
}

- (void)didClickedInButton2:(UIButton *)btn2 {
    self.btn1.selected = NO;
    self.btn2.selected = YES;
    self.pickerView.btnIndex = time2Button;
    [UIView animateWithDuration:0.35 animations:^{
        self.pickerView.frame = showFrame;
    }];
}

#pragma mark - delegate
- (void)remakeTime:(NSString *)newTime withButtonIndex:(NSInteger)btnIndex{
    if (btnIndex == time1Button) {
        [self.btn1 setTitle:newTime forState:UIControlStateNormal];
    }
    else if (btnIndex == time2Button) {
        [self.btn2 setTitle:newTime forState:UIControlStateNormal];
    }
}

#pragma mark - 字符串->date
- (NSDate *)timeDateWithString:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //  设置日期格式
    [formatter setDateFormat:@"HHmm"];
    //  根据指定格式的字符串获取NSDate
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//页面消失，进入后台不显示该页面，关闭定时器
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //关闭定时器
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)dealloc {
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
