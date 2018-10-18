//
//  Rice1RVersion1ViewPages.m
//  thColorSort
//
//  Created by huanghu on 2018/2/27.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "Rice1RVersion1ViewPages.h"
#import "Rice1RColorAdvancedView.h"
#import "Rice1RDiffAdvancedView.h"
#import "RiceLengthView.h"
#import "RiceBrokenView.h"
#import "Rice20CalibrationView.h"
#import "Rice20SenseView.h"
@implementation Rice1RVersion1ViewPages

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
-(void)createPage{
    [super createPage];
    [self.VersionViewNameToClassDictionary setObject:[Rice1RColorAdvancedView class] forKey:@"ColorAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[Rice1RDiffAdvancedView class] forKey:@"DiffAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[RiceLengthView class] forKey:@"RiceLengthView"];
    [self.VersionViewNameToClassDictionary setObject:[RiceBrokenView class] forKey:@"RiceBrokenView"];
    [self.VersionViewNameToClassDictionary setObject:[Rice20CalibrationView class] forKey:@"CameraCalibrationView"];
#ifdef Engineer

#else
    [self.VersionViewNameToClassDictionary setObject:[Rice20SenseView class] forKey:@"SenseView"];
#endif
    
}
@end
