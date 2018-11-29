//
//  ShapeViewModel.h
//  thColorSort
//
//  Created by 黄虎 on 2018/11/22.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct MiniItem
{
    Byte   itemIndex; //形选具体算法  灵敏度 、最小长度
    char name[50];
    Byte value[2];
    Byte max[2];
    Byte min[2];
}MiniItem;
typedef struct  ShapeItem
{
    Byte    shapeType;//形选类型  基础形选/花生/小麦.....
    Byte    shapeId;//形选项  选长 选短
    char name[50];
    Byte    used;
    Byte    mutex;//互斥的shapeId   默认255  则没有
    Byte    count;//MiniItem 的数量
    MiniItem *miniItem;
}ShapeItem;
typedef struct Shape
{
    Byte    shapeType;//形选类型  基础形选/花生/小麦.....
    Byte    shapeItemCount;
    char  shapeName[50];
    ShapeItem *shapeItem;
}Shape;
@interface ShapeViewModel : NSObject
{
    @public
    Shape *pShape;
}
@property (nonatomic,assign) Byte shapeCount;
-(void)fetchData:(NSData *)data;
@end
