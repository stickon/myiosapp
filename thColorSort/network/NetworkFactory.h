//
//  NetworkFactory.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/4/5.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"
@interface NetworkFactory : NSObject
+(void)createNetworkWithType:(Byte)type;
+(Network*)sharedNetWork;
@end
