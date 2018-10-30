//
//  BaseVersionViewPages.m
//  ThColorSortNew
//
//  Created by huanghu on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "BaseVersionViewPages.h"
#import "SelectLoginView.h"
#import "LoginUI.h"
#import "RegisterView.h"
#import "LanguageSettingView.h"
#import "DeviceListUI.h"
#import "HomeView.h"
#import "SenseView.h"
#import "SysinfoView.h"
#import "SettingView.h"
#import "ColorAlgorithmView.h"
#import "IRAlgorithmView.h"
#import "FeedSetView.h"
#import "CleanSetView.h"
#import "ModeListView.h"
#import "ModeSetView.h"
#import "CaterpillarView.h"
#import "CalibrationView.h"
#import "SignalSettingView.h"
#import "SoftwareVersionView.h"
#import "SyscheckInfoView.h"
#import "SysworkTimeView.h"
#import "ValveShowInfoView.h"
#import "RunningLogView.h"
#import "ValveSetView.h"
#import "HsvView.h"
#import "SvmView.h"
@implementation BaseVersionViewPages
-(instancetype)init{
    if (self = [super init]) {
        self.VersionViewNameToClassDictionary = [[NSMutableDictionary alloc] init];
        [self createPage];
    }
    return self;
}
- (void)createPage {
    [self.VersionViewNameToClassDictionary setObject:[SelectLoginView class] forKey:@"SelectLoginView"];
    [self.VersionViewNameToClassDictionary setObject:[LoginUI class] forKey:@"LoginUI"];
    [self.VersionViewNameToClassDictionary setObject:[DeviceListUI class] forKey:@"DeviceListUI"];
    [self.VersionViewNameToClassDictionary setObject:[HomeView class] forKey:@"HomeView"];
    [self.VersionViewNameToClassDictionary setObject:[FeedSetView class] forKey:@"FeedSetView"];
    [self.VersionViewNameToClassDictionary setObject:[CleanSetView class] forKey:@"CleanSetView"];
    [self.VersionViewNameToClassDictionary setObject:[SenseView class] forKey:@"SenseView"];
    [self.VersionViewNameToClassDictionary setObject:[SysinfoView class] forKey:@"SysinfoView"];
    [self.VersionViewNameToClassDictionary setObject:[SettingView class] forKey:@"SettingView"];
    [self.VersionViewNameToClassDictionary setObject:[ColorAlgorithmView class] forKey:@"ColorAlgorithmView"];
    [self.VersionViewNameToClassDictionary setObject:[IRAlgorithmView class] forKey:@"IRAlgorithmView"];
    [self.VersionViewNameToClassDictionary setObject:[ModeListView class] forKey:@"ModeListView"];
    [self.VersionViewNameToClassDictionary setObject:[ModeSetView class] forKey:@"ModeSetView"];
    [self.VersionViewNameToClassDictionary setObject:[CalibrationView class] forKey:@"CalibrationView"];
    [self.VersionViewNameToClassDictionary setObject:[SignalSettingView class] forKey:@"SignalSettingView"];
    [self.VersionViewNameToClassDictionary setObject:[RegisterView class] forKey:@"RegisterView"];
    [self.VersionViewNameToClassDictionary setObject:[LanguageSettingView class] forKey:@"LanguageSettingView"];
    [self.VersionViewNameToClassDictionary setObject:[SoftwareVersionView class] forKey:@"SoftwareVersionView"];
    [self.VersionViewNameToClassDictionary setObject:[SyscheckInfoView class] forKey:@"SyscheckInfoView"];
    [self.VersionViewNameToClassDictionary setObject:[SysworkTimeView class] forKey:@"SysworkTimeView"];
    [self.VersionViewNameToClassDictionary setObject:[ValveShowInfoView class] forKey:@"ValveShowInfoView"];
    [self.VersionViewNameToClassDictionary setObject:[RunningLogView class] forKey:@"RunningLogView"];
    [self.VersionViewNameToClassDictionary setObject:[ValveSetView class] forKey:@"ValveSetView"];
    [self.VersionViewNameToClassDictionary setObject:[HsvView class] forKey:@"HsvView"];
    [self.VersionViewNameToClassDictionary setObject:[SvmView class] forKey:@"SvmView"];
    [self.VersionViewNameToClassDictionary setObject:[CaterpillarView class] forKey:@"CaterpillarView"];
}

@end
