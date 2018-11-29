//
//  HsvColorPaletteView.h
//  thColorSort
//
//  Created by huanghu on 2017/8/8.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common_struct.h"
@protocol HsvColorPaletteChangeHsvDelegate<NSObject>
- (void) hsvColorPaletteSetIndex:(int)index;
@end
@interface HsvColorPaletteView : UIView{
    @public
    int HsvSstart[2];
    int hsvSend[2];
    int hsvVstart[2];
    int hsvVend[2];
    int hsvHstart[2];
    int hsvHend[2];
    int currentHsvIndex;
    int lightColorIndex;
    Byte hsvUsed[2];
    Byte pointX[1024];
    Byte pointY[1024];
    Byte lightY[256];
    HsvSense hsv[6];
    int hsvCount;
}
@property (nonatomic,assign) int offset;
@property (nonatomic,assign) Byte used;
@property (nonatomic,weak) id<HsvColorPaletteChangeHsvDelegate> delegate;
-(void)setIsoffset:(int)offset;
-(int)getHsvH1;
-(int)getHsvH2;
-(int)getHsvS1;
-(int)getHsvS2;
@end
