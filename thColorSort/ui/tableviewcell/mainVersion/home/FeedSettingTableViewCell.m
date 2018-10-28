//
//  FeedSettingTableViewCell.m
//  thColorSort
//
//  Created by huanghu on 2017/6/26.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "FeedSettingTableViewCell.h"

@implementation FeedSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.hidden = YES;
    self.feedNumTextField.tag = 1;
    self.feedSwitch.tag = 2;
    self.feedSwitch.onTintColor = [UIColor TaiheColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)feedSwitchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}

- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:99 Min:1 Value:sender.text.integerValue];
}
- (IBAction)btnClicked:(UIButton *)sender {
        [super cellEditValueChangedWithTag:sender.tag AndValue:1 bSend:YES];
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.intValue];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.feedCellTitle.frame = CGRectMake(0, 0, 80, 40);
//    self.feedNumTextField.frame = CGRectMake(self.frame.size.width/2-30, 4, 49, 36);
//    self.feedSwitch.frame = CGRectMake(self.frame.size.width-60, 6, 49, 31);
}

@end
