//
//  ModeSetView.h
//  thColorSort
//
//  Created by huanghu on 2018/1/11.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "BaseUI.h"
typedef struct Mode //方案
{
    Byte rgbSpot[2][2];             //[前/后] [上限/下限]是否使用
    Byte rgbSpotColor[2];           //[前/后], 颜色索引
    Byte rgbArea[2][2];             //
    Byte rgbAreaColor[2];              //
    Byte diff1[2][3];              //色差1  1：是否使用，2：颜色索引 3：亮度限制颜色索引
    Byte diff2[2][3];              //色差2
    Byte FrontRearRelation ;         //前与后
    //红外部分
    Byte irRgb[2][2];             //[前/后] [上限/下限]是否使用
    Byte irRgbColor[2];         //[前/后], 颜色索引
    Byte irDiff[2];             //[前/后] 是否使用
    Byte irDiffColor[2];         //[前/后], 颜色索引
    Byte lightLimit[2];          //[前/后]亮度区域使用
    Byte lightLimitColor[2];     //[前/后]亮度区域颜色
}Mode;
@interface ModeSetView : BaseUI
{
    Mode *mode;
    Byte useSvm;
    Byte shape;
    Byte useHsv;
}

@end
