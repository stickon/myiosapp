//
//  SingleViewSvm.h
//  thColorSort
//
//  Created by 黄虎 on 2018/10/30.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ResponderAuto.h"
#import "common_struct.h"
@interface SingleViewSvm : ResponderAuto
-(void)updateViewWithData:(SvmInfo*)svminfo;
@end
