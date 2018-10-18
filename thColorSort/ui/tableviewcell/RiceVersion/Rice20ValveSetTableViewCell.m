//
//  Rice20ValveSetTableViewCell.m
//  thColorSort
//
//  Created by huanghu on 2018/2/23.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "Rice20ValveSetTableViewCell.h"
@interface Rice20ValveSetTableViewCell()<MyTextFieldDelegate>

@end
@implementation Rice20ValveSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.valveWorkModeComboBox = [[UIComboBox alloc]init];
    self.valveWorkModeComboBox.frame = CGRectMake(self.valveOpenTimeTextField.frame.origin.x, self.valveWorkModeTitleLabel.frame.origin.y+12-18, 120, 36);
    
    self.valveWorkModeComboBox.selectedItem = 0;
    __block Rice20ValveSetTableViewCell *blockSelf = self;
    [self.valveWorkModeComboBox setOnItemSelected:^(NSString *selectedObject,NSInteger selectedIndex){
        if ([blockSelf.delegate respondsToSelector:@selector(cellValueChangedWithSection:row:tag:value:)]) {
            [blockSelf.delegate cellValueChangedWithSection:blockSelf.indexPath.section row:blockSelf.indexPath.row tag:(int)blockSelf.valveWorkModeComboBox.tag value:selectedIndex];
        }
    }];
    [self.contentView addSubview:self.valveWorkModeComboBox];
    self.valveOpenTimeTextField.tag = 1;
    self.valveWorkModeComboBox.tag = 2;
    self.delayTimeTextField.tag = 3;
    self.blowTimeTextField.tag = 4;
    self.ejectTypeSegmentedControl.tag = 5;
    self.centerPointSwitch.tag = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Byte value = sender.text.intValue;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}

- (IBAction)MytextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 3) {
        [sender initKeyboardWithMax:255 Min:8 Value:sender.text.integerValue];
    }else if (sender.tag == 4){
        [sender initKeyboardWithMax:160 Min:12 Value:sender.text.integerValue];
    }else if (sender.tag == 1){
        [sender initKeyboardWithMax:12 Min:7 Value:sender.text.integerValue];
    }
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    Byte value = sender.selectedSegmentIndex;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    CGFloat frameWidth = self.frame.size.width;
//    [self.delayTimeTextField setFrame:CGRectMake(frameWidth/5*1-10, 4, 50, 36)];
//    [self.blowTimeTextField setFrame:CGRectMake(frameWidth/5*2-10, 4, 50, 36)];
//    [self.ejectTypeSegmentedControl setFrame:CGRectMake(frameWidth/5*3-10, 4, 50, 36)];
//    [self.centerPointSwitch setFrame:CGRectMake(frameWidth/5*4-10, 4, 50, 36)];
}
@end
