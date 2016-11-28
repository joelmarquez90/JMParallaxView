//
//  JMAppDelegate.m
//  JMParallaxView
//
//  Created by Joel Marquez on 11/28/2016.
//  Copyright (c) 2016 Joel Marquez. All rights reserved.
//

#import "JMAppDelegate.h"

#import "JMViewController.h"

@implementation JMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:[JMViewController new]];
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
