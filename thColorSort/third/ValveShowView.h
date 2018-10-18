//
//  ValveShowView.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/4/24.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValveShowView : UIView
{
    @public
    Byte *frontValveFrequency;
    Byte *rearValveFrequency;
}
@property(nonatomic,assign) NSInteger valveNum;

-(void)bindValveData:(Byte*)valveData withValveNum:(Byte)valveNum HasRearView:(Byte)rearView;
@end
