//
//  AppDelegate.m
//  WJXDateFormatterBenchmark
//
//  Created by Jiuxing Wang on 2020/1/30.
//  Copyright © 2020 Jiuxing Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "BenchmarkViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = ({
        UIViewController *vc = [[BenchmarkViewController alloc] init];
        [[UINavigationController alloc] initWithRootViewController:vc];
    });
    [_window makeKeyAndVisible];

    return YES;
}

@end
