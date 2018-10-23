//
//  VersionViewPageManager.m
//  ThColorSortNew
//
//  Created by huanghu on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "VersionViewPageManager.h"
#import "Version31ViewPages.h"
#import "Version21ViewPages.h"
#import "Version30ViewPages.h"
#import "RiceUserVersion20ViewPages.h"
#import "Rice1RVersion1ViewPages.h"
#import "DataModel.h"
#import "types.h"
@implementation VersionViewPageManager
+ (VersionViewPageManager *)shareInstance {
    static VersionViewPageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(BaseVersionViewPages*)curVersionViewPages{
    if (!_curVersionViewPages) {
        _curVersionViewPages = [[BaseVersionViewPages alloc] init];
    }
    return _curVersionViewPages;
}

-(void)setPages{
    if (kDataModel.currentDevice->screenProtocolType == 0) {
        if (kDataModel.currentDevice->screenProtocolMainVersion == 0) {
            if (kDataModel.currentDevice->screenProtocolMinVersion == 0) {
             
            }
        }
        else if (kDataModel.currentDevice->screenProtocolMainVersion == 2&&kDataModel.currentDevice->screenProtocolMinVersion ==0) {
            _curVersionViewPages = [[Version21ViewPages alloc] init];
        }else if (kDataModel.currentDevice->screenProtocolMainVersion == 3){
            if (kDataModel.currentDevice->screenProtocolMinVersion ==0) {
                _curVersionViewPages = [[Version30ViewPages alloc] init];
            }else if (kDataModel.currentDevice->screenProtocolMinVersion ==1){
            _curVersionViewPages = [[Version31ViewPages alloc] init];
            }
        }
    }
    if (kDataModel.currentDevice->screenProtocolType == 1) {
        if (kDataModel.currentDevice->screenProtocolMainVersion == 2&&kDataModel.currentDevice->screenProtocolMinVersion ==0) {
            _curVersionViewPages = [[RiceUserVersion20ViewPages alloc] init];
        }
    }
    if (kDataModel.currentDevice->screenProtocolType == 2) {
        _curVersionViewPages = [[Rice1RVersion1ViewPages alloc] init];
    }
    
}
@end
