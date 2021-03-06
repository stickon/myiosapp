//
//  MyGroupView.m
//  thColorSort
//
//  Created by huanghu on 2017/11/9.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "MyGroupView.h"
#import "types.h"
@interface MyGroupView(){
        NSInteger selectIndex;
}
@end
@implementation MyGroupView
- (void)setGroupNum:(NSInteger)num Title:(NSArray *)titleArr SelectedIndex:(Byte)selectedIndex{
    groupNum = num;
    selectIndex = selectedIndex;
    NSArray<UIButton*> *layerBtns = [self subviews];
    for (UIButton* btn in layerBtns) {
        [btn removeFromSuperview];
    }
    for (int i = 0; i < num; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(self.frame.size.width-(num-1)*2)/num+i*2,0, (self.frame.size.width-(num-1)*2)/num, self.frame.size.height)];
        [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 0.0f;
        [btn addTarget:self action:@selector(groupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == selectIndex) {
            btn.backgroundColor = [UIColor greenColor];
        }
        else{
            btn.backgroundColor = [UIColor TaiheColor];
        }
        btn.tag = i;
        [self addSubview:btn];
    }
}
- (void)groupBtnClicked:(UIButton*)sender{
    selectIndex = sender.tag;
    NSArray<UIButton*> *layerBtns = [self subviews];
    for (UIButton* btn in layerBtns) {
        if (btn.tag<7) {
            if (btn.tag != selectIndex) {
                btn.backgroundColor = [UIColor TaiheColor];
                btn.userInteractionEnabled = YES;
            }
            else{
                btn.backgroundColor = [UIColor greenColor];
                btn.userInteractionEnabled = NO;
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupBtnClicked:)]) {
        [self.delegate groupBtnClicked:sender.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSArray<UIButton*> *layerBtns = [self subviews];

    for (int i = 0; i < groupNum; i++) {
        layerBtns[i].frame = CGRectMake(i*(self.frame.size.width)/groupNum,0, (self.frame.size.width)/groupNum, self.frame.size.height);
    }
}
@end
