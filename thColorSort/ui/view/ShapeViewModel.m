//
//  ShapeViewModel.m
//  thColorSort
//
//  Created by 黄虎 on 2018/11/22.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ShapeViewModel.h"
@implementation ShapeViewModel
- (instancetype)init{
    if (self == [super init]) {
        pShape = NULL;
    }
    return self;
}

-(void)fetchData:(NSData *)data{
    const char* a = data.bytes;
    self.shapeCount = 1;
    if (pShape) {
        free(pShape);
    }
    pShape = malloc(sizeof(pShape)*self.shapeCount);
    Byte shapeindex = 0,shapeItemIndex  = 0,miniIndex = 0;
    int32_t offset = 15;
    while (shapeindex<self.shapeCount && offset <data.length) {
        memcpy(pShape+shapeindex,a+offset,52);
        pShape[shapeindex].shapeItem = malloc(sizeof(ShapeItem)*pShape[shapeindex].shapeItemCount);
        
        offset+= 52;
        shapeItemIndex = 0;
        while (shapeItemIndex<pShape[shapeindex].shapeItemCount) {
            memcpy(pShape[shapeindex].shapeItem+shapeItemIndex,a+offset, 55);
            offset+=55;
            miniIndex = 0;
            pShape[shapeindex].shapeItem[shapeItemIndex].miniItem = malloc(pShape[shapeindex].shapeItem[shapeItemIndex].count*sizeof(MiniItem));
            
            while (miniIndex < pShape[shapeindex].shapeItem[shapeItemIndex].count) {
           memcpy(&(pShape[shapeindex].shapeItem[shapeItemIndex].miniItem[miniIndex]),a+offset,sizeof(MiniItem));
                miniIndex++;
                offset+=57;
            }
            shapeItemIndex++;
        }
        shapeindex++;
    }
    
}
@end
