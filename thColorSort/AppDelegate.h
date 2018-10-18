//
//  AppDelegate.h
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <AvoidCrash/AvoidCrash.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    @public
    DDFileLogger *fileLogger;
}
@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)delegate;
-(void)removeLog;
@end

