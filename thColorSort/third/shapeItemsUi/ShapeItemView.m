//
//  ShapeItemView.m
//  thColorSort
//
//  Created by 黄虎 on 2018/11/25.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ShapeItemView.h"

@implementation ShapeItemView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewxib = [[NSBundle mainBundle]loadNibNamed:@"ShapeItemView" owner:self options:nil];
        self = [viewxib objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}
@end
