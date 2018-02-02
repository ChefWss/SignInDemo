//
//  MainTabBarController.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "TabOneVC.h"
#import "TabTwoVC.h"

@interface MainTabBarController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildViewControllers];
    [self setTabbarColor];
}

- (void)setTabbarColor {
    UITabBar *tabBar = [UITabBar appearance];
    [tabBar setBarTintColor:kNavGrayColor];
    tabBar.translucent = NO;
}


- (void)setupAllChildViewControllers {
    [self setupChildViewController:[[TabOneVC alloc] init] Title:@"打卡" ImageName:@"tabbar-1" SelectedImageName:@"tabbar-1-color"];
    [self setupChildViewController:[[TabTwoVC alloc] init] Title:@"记录" ImageName:@"tabbar-2" SelectedImageName:@"tabbar-2-color"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc Title:(NSString *)title ImageName:(NSString *)imageName SelectedImageName:(NSString *)selectedImageName {
    
    childVc.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //常规字体颜色
    [childVc.tabBarItem setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    //选中字体颜色
    [childVc.tabBarItem setTitleTextAttributes: @{NSForegroundColorAttributeName:kAppOrangeColor} forState:UIControlStateSelected];
    
    
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    [nav.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[Tool colorWithHexString:@"#dbdbdb"], NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    [self addChildViewController:nav];
    nav.interactivePopGestureRecognizer.enabled = YES;
    nav.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - 系统侧滑手势返回
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UINavigationController *nav=self.childViewControllers[self.selectedIndex];
    if (nav.childViewControllers.count==1) {
        return NO;
    }
    return YES;
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
