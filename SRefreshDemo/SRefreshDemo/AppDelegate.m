//
//  AppDelegate.m
//  SRefreshDemo
//
//  Created by S on 15/11/9.
//  Copyright © 2015年 S. All rights reserved.
//

#import "AppDelegate.h"
#import "Masonry.h"
#import "ViewController.h"
#import "StartView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ViewController * vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    // 添加启动动画
    //    [self startAnimation];
    
    return YES;
}

#pragma mark - 启动动画
- (void)startAnimation {
    
    __block UIImageView * BaseImageView = [UIImageView new];
    BaseImageView.image = [UIImage imageNamed:@"blackBG"];
    [self.window addSubview:BaseImageView];
    [BaseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.centerY.equalTo(self.window);
    }];
    
    StartView * view = [[StartView alloc]init];
    view.time = 4;
    [view loadAnimationWithView:BaseImageView];
    
    
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, view.time* NSEC_PER_SEC);
    NSLog(@"%llu",delayInNanoSeconds);
    // 延迟执行
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            BaseImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [BaseImageView removeFromSuperview];
        }];
    });
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
