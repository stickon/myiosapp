//
//  AppDelegate.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
static AppDelegate *appDelegate = nil;
@implementation AppDelegate

+ (AppDelegate *)delegate{
    return appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    appDelegate = self;
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    fileLogger = [[DDFileLogger alloc] init];
    //保存周期
    fileLogger.rollingFrequency = 660 * 660 * 24; // 24 hour rolling
    //最大的日志文件数量
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    [AvoidCrash becomeEffective];
    
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    return YES;
}

-(void)dealwithCrashMessage:(NSNotification*)note{
    DDLogInfo(@"%@",note.userInfo);
}
-(void)removeLog{
    [DDLog removeLogger:fileLogger];
    [DDLog addLogger:fileLogger];
    [DDLog flushLog];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
