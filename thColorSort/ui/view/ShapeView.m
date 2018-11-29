//
//  ShapeView.m
//  thColorSort
//
//  Created by 黄虎 on 2018/11/13.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ShapeView.h"
#import "ShapeViewModel.h"
#import "MyGroupView.h"
#import "ShapeItemView.h"
#import "ShapeMiniItemView.h"
#import "TipsView.h"
@interface ShapeView()<GroupBtnDelegate>
@property (strong,nonatomic) ShapeViewModel *model;
@property (strong, nonatomic) IBOutlet MyGroupView *groupView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end
@implementation ShapeView


-(instancetype)init{
    if (self = [super init]) {
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ShapeView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(void)initView{
    [self updateGroupBtnHidden];
}
-(void)updateGroupBtnHidden{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
    }else{
        if (device->machineData.groupNum<=1) {
            self.groupView.hidden = YES;
        }else{
            NSArray *arr = [NSArray array];
            for (int i = 0; i < device->machineData.groupNum; i++) {
                arr = [arr arrayByAddingObject:[NSString stringWithFormat:@"%@ %d",kLanguageForKey(372),i+1]];
            }
            if (self.groupView->groupNum != device->machineData.groupNum) {
                [self.groupView setGroupNum:device->machineData.groupNum Title:arr SelectedIndex:0];
            }
            
            self.groupView.hidden = NO;
            
        }
    }
}
-(ShapeViewModel *)model{
    if (!_model) {
        _model = [[ShapeViewModel alloc] init];
    }
    return _model;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self refreshCurrentView];
    return self;
}
-(void)refreshCurrentView{
    Device *device = kDataModel.currentDevice;
    [gNetwork getShapeWithGroup:device.currentGroupIndex];
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char *a = headerData.bytes;
    if (a[0] == 0x11){
        if (a[1] == 1) {
            [self.model fetchData:headerData];
            [self updateScrollView];
        }else if (a[1] == 2){
            [self refreshCurrentView];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getSvmPara];
    }
}
-(void)groupBtnClicked:(Byte)index{
    Device *device = kDataModel.currentDevice;
    if (index != device.currentGroupIndex) {
        device.currentGroupIndex = index;
        [self refreshCurrentView];
    }
}
-(void)updateScrollView{
    Byte shapeIndex = 0,shapeItemIndex = 0,miniItemIndex = 0;
    CGFloat CGFloatY = self.scrollView.frame.origin.x;
    CGFloat width = self.frame.size.width;
    while (shapeIndex < self.model.shapeCount) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatY, width, 40)];
        label.text =[NSString stringWithUTF8String:self.model->pShape[shapeIndex].shapeName];
        [self.scrollView addSubview:label];
        CGFloatY+=40;
        shapeItemIndex =0;
        while (shapeItemIndex < self.model->pShape[shapeIndex].shapeItemCount) {
            ShapeItemView *shapeItem = [[ShapeItemView alloc] initWithFrame:CGRectMake(0, CGFloatY, width, 40)];
            [self.scrollView addSubview:shapeItem];
            CGFloatY+=40;
            miniItemIndex = 0;
            while (miniItemIndex < self.model->pShape[shapeIndex].shapeItem[shapeItemIndex].count) {
                NSLog(@"miniCount:%d",self.model->pShape[shapeIndex].shapeItem[shapeItemIndex].count);
                ShapeMiniItemView *miniItem = [[ShapeMiniItemView alloc]initWithFrame:CGRectMake(0, CGFloatY, width, 40)];
                [self.scrollView addSubview:miniItem];
                CGFloatY+=40;
                miniItemIndex++;
            }
            
            shapeItemIndex++;
        }
        shapeIndex++;
    }
    [self.scrollView setContentSize:CGSizeMake(width, CGFloatY)];
}
@end
