//
//  AppDelegate.m
//  518
//
//  Created by 郎烨 on 2021/7/26.
//

#import "AppDelegate.h"
#import "YD518PlanHomeViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initialzeNetWork];
    [self initialize518Project];
    return YES;
}

/**
 初始化518计划
 */
- (void)initialize518Project {
    YD518PlanHomeViewController *rootVC = [YD518PlanHomeViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
}

/**
 初始化网络
 */
- (void)initialzeNetWork {
    [NXNetWorkHelper initialize];
}

@end
