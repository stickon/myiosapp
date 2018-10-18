//
//  RiceUserVersion20ViewPages.m
//  thColorSort
//
//  Created by huanghu on 2018/2/7.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "RiceUserVersion20ViewPages.h"
#import "Rice20SenseView.h"
#import "Rice20ValveSetView.h"
#import "Rice20CalibrationView.h"
#import "RiceColorAdvancedView.h"
#import "RiceDiffAdvancedView.h"
#import "SvmGroup31View.h"
#import "RiceLengthView.h"
#import "RiceBrokenView.h"
@implementation RiceUserVersion20ViewPages

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
-(void)createPage{
    [super createPage];
#ifdef Engineer
    [self.VersionViewNameToClassDictionary setObject:[Rice20ValveSetView class] forKey:@"ValveSetView"];
    [self.VersionViewNameToClassDictionary setObject:[RiceColorAdvancedView class] forKey:@"ColorAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[RiceDiffAdvancedView class] forKey:@"DiffAdvancedView"];
#else
    [self.VersionViewNameToClassDictionary setObject:[Rice20SenseView class] forKey:@"SenseView"];
#endif
    [self.VersionViewNameToClassDictionary setObject:[Rice20CalibrationView class] forKey:@"CameraCalibrationView"];
    [self.VersionViewNameToClassDictionary setObject:[SvmGroup31View class] forKey:@"SvmView"];
    [self.VersionViewNameToClassDictionary setObject:[RiceLengthView class] forKey:@"RiceLengthView"];
    [self.VersionViewNameToClassDictionary setObject:[RiceBrokenView class] forKey:@"RiceBrokenView"];
}
@end
