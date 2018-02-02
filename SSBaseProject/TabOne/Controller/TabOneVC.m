//
//  TabOneVC.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "TabOneVC.h"
#import "ParticleView.h"

@interface TabOneVC ()

@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) NSTimer *time_timer;
@property(nonatomic, strong) NSTimer *animation_timer;
@property(nonatomic, strong) ParticleView *v;

@end

@implementation TabOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"打卡";
    [self createUI];
    
    //打开数据库并新建表
    [[DBObject sharedInstance] addDatabaseAndTableMethod];
    [DBObject sharedInstance].currrentView = self.view;
    [[DBObject sharedInstance] selectWithDate:[Tool getTodayDate]];
    
    self.time_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.time_timer forMode:NSDefaultRunLoopMode];

}

- (void)action:(NSTimer *)sender {
    if ([sender isEqual:self.time_timer]) {
        self.timeLabel.text = [Tool getCurrentTime];
    }
    else if ([sender isEqual:self.animation_timer]) {
        self.v.angleNum = 0;
        [self.v animation];
    }
}

- (void)createUI {
    
    self.v = [[ParticleView alloc] init];
    self.v.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:self.v];
    self.v.angleNum = 0.5;
    self.v.filterTime = 1000 * 60 * 60 * 8;
    self.v.count = 0;
    self.v.count = 100;
    [self run];
    
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kPERCENT(-20), WIDTH, kPERCENT(20))];
    _tipLabel.font = FONT_RATIO(14);
    _tipLabel.backgroundColor = RGBA(233, 143, 54, 0.3);
    _tipLabel.textColor = [UIColor grayColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.text = @"温馨提示:每天只记录两次打卡时间";
    [self.view addSubview:_tipLabel];
    

    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:kPERCENT(65)];
    _timeLabel.textColor = kAppOrangeColor;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = [Tool getCurrentTime];
    [self.view addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.equalTo(self.view);
        make.height.equalTo(WIDTH * 0.6);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"打卡" forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_RATIO(20);
    SetViewBorder(btn, kPERCENT(70), 1.2f, [UIColor grayColor]);
    [btn setTitleColor:kAppOrangeColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClickedInButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.and.height.equalTo(kPERCENT(140));
        make.top.equalTo(self.timeLabel.bottom).offset(kPERCENT(85));
    }];
    
}

- (void)run {
    [self.animation_timer invalidate];
    self.animation_timer = nil;
    self.animation_timer = [NSTimer scheduledTimerWithTimeInterval:1 / 30.0f target:self selector:@selector(action:) userInfo:nil repeats:YES];
    self.animation_timer.tolerance = 0;
    [[NSRunLoop currentRunLoop] addTimer:self.animation_timer forMode:NSRunLoopCommonModes];
}


- (void)didClickedInButton {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"当前时间打卡" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self createDB];

    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"补填打卡时间" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self presentViewController:[Tool showAlertTitle:@"暂未开放,敬请期待!" btnMsg:@"OK"] animated:YES completion:nil];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //添加按钮
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    //显示警报控制器
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - DB
- (void)createDB {

    //添加数据
    [[DBObject sharedInstance] insetDate:[Tool getTodayDate] time:[Tool getCurrentMinuteTime]];
    [self presentViewController:[Tool showAlertTitle:@"记录成功!" btnMsg:@"知道了"] animated:YES completion:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.tipLabel.frame = CGRectMake(0, 0, WIDTH, kPERCENT(20));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            self.tipLabel.frame = CGRectMake(0, kPERCENT(-20), WIDTH, kPERCENT(20));
        }];
    });
}

//页面将要进入前台，开启定时器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //开启定时器
    if (_time_timer) {
        [_time_timer setFireDate:[NSDate distantPast]];
    }
    if (_animation_timer) {
        [_animation_timer setFireDate:[NSDate distantPast]];
    }
}

//页面消失，进入后台不显示该页面，关闭定时器
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //关闭定时器
    if (_time_timer) {
        [_time_timer setFireDate:[NSDate distantFuture]];
    }
    if (_animation_timer) {
        [_animation_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)dealloc {
    if (_time_timer) {
        if ([_time_timer isValid]) {
            [_time_timer invalidate];
            _time_timer = nil;
        }
    }
    if (_animation_timer) {
        if ([_animation_timer isValid]) {
            [_animation_timer invalidate];
            _animation_timer = nil;
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
