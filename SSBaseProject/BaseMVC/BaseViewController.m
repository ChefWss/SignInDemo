//
//  BaseViewController.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kNavGrayColor;
    
    //取消导航栏毛玻璃半透明效果
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kNavGrayColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = kAppOrangeColor;
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
