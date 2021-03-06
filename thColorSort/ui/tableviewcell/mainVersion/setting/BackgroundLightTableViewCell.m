//
//  BackgroundLightTableViewCell.m
//  thColorSort
//
//  Created by huanghu on 2017/6/16.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "BackgroundLightTableViewCell.h"
@interface BackgroundLightTableViewCell()<MyTextFieldDelegate>
@end
@implementation BackgroundLightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundLightTitleLabel.textColor = [UIColor TaiheColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)MyTextFieldEditingDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
}

- (void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.integerValue];
}
@end
