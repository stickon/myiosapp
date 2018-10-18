//
//  Version30ViewPages.m
//  thColorSort
//
//  Created by huanghu on 2018/3/15.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "Version30ViewPages.h"
#import "SvmGroup31View.h"
#import "Peanut31View.h"

@implementation Version30ViewPages
-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
-(void)createPage{
    [super createPage];
    [self.VersionViewNameToClassDictionary setObject:[SvmGroup31View class] forKey:@"SvmView"];
    [self.VersionViewNameToClassDictionary setObject:[Peanut31View class] forKey:@"PeanutView"];
}
@end
