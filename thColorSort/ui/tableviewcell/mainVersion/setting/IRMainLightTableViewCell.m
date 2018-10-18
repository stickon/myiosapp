//
//  IRMainLightTableViewCell.m
//  thColorSort
//
//  Created by huanghu on 2017/6/16.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "IRMainLightTableViewCell.h"

@implementation IRMainLightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.on];
}

@end
