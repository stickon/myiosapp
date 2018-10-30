//
//  SingleViewSvm.m
//  thColorSort
//
//  Created by 黄虎 on 2018/10/30.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SingleViewSvm.h"
@interface SingleViewSvm()
@end
@implementation SingleViewSvm

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SingleViewSvm" owner:self options:nil] firstObject];
  
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    
    return self;
}

@end
