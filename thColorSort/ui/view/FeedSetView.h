//
//  FeedSetView.h
//  thColorSort
//
//  Created by huanghu on 2018/1/9.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUI.h"
struct VibSetNew
{
    Byte ch;               //给料量通道数
    Byte group;        //给料量分组数
    Byte groupData[4];   // 每组给料量
    Byte groupOpen[4];   // 每组开关状态
    Byte vibdata[10];   // 每个通道的给料量
    Byte vibOpen[10];  // 每个通道的给料量开关
};

@interface FeedSetModel:NSObject
{
    @public
    struct VibSetNew vib;
}
-(void)fetchData:(NSData*)data;
@end

@interface FeedSetView : BaseUI

@end
