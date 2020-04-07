//
//  AppDelegate.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc]init]];

    self.window.rootViewController = navi;

    [self.window makeKeyAndVisible];

    return YES;
}




@end
