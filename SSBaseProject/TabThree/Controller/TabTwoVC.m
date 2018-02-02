//
//  TabTwoVC.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "TabTwoVC.h"
#import "SignInListTableCell.h"
#import "ChangeTimeVC.h"

@interface TabTwoVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation TabTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"本月记录";
    [self createBarButton];
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - kTabBarH - kNavigationBarH - kStatusBarH)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)createBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:GetImgWithName(@"year") style:UIBarButtonItemStylePlain target:self action:@selector(didClickedInRightBarBtn)];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
    [rightBtn setTitle:@"统计" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kAppOrangeColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.borderWidth = 1;
    rightBtn.layer.cornerRadius = 4.5f;
    rightBtn.layer.borderColor = kAppOrangeColor.CGColor;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.leftBarButtonItem = left;
    [rightBtn addTarget:self action:@selector(didClickedInLeftBarBtn) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - barbtn点击事件
- (void)didClickedInLeftBarBtn {
    
}

- (void)didClickedInRightBarBtn {
    
}



#pragma mark - table delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DBObject sharedInstance].arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPERCENT(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignInListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignInListTableCell"];
    if (!cell) {
        cell = [[SignInListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SignInListTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell createLabelWithDic:[[DBObject sharedInstance].arr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangeTimeVC *vc = [[ChangeTimeVC alloc] init];
    NSMutableDictionary *dic = [[DBObject sharedInstance].arr objectAtIndex:indexPath.row];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[DBObject sharedInstance] selectAllMethod];
    [self.tableView reloadData];
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
