//
//  RiceSharpenTableViewCell.m
//  thColorSort
//
//  Created by huanghu on 2017/12/11.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "RiceSharpenTableViewCell.h"

@implementation RiceSharpenTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    NSInteger value = sender.text.integerValue;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    [self.SharpenParaTitleLabel setFrame:CGRectMake(20,4 , 80, 36)];
    [self.SharpenParaTextField setFrame:CGRectMake(self.SharpenParaTitleLabel.frame.size.width+20, 5, 50, 40)];
    [self.SharpenUseTitleLabel setFrame:CGRectMake(width/2+20, 5, 60, 40)];
    [self.SharpenUseSwitch setFrame:CGRectMake(width/2 +80, 10, 60, 31)];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
