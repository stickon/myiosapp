//
//  RiceUserVersion20ViewPages.m
//  thColorSort
//
//  Created by huanghu on 2018/2/7.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "RiceUserVersion20ViewPages.h"
#import "SvmGroup31View.h"
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
#endif
    [self.VersionViewNameToClassDictionary setObject:[SvmGroup31View class] forKey:@"SvmView"];
}
@end
