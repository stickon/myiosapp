//
//  Rice20SenseSizeTableViewCell.m
//  thColorSort
//
//  Created by huanghu on 2018/2/24.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "Rice20SenseSizeTableViewCell.h"
#import "types.h"
@interface Rice20SenseSizeTableViewCell()<MyTextFieldDelegate,GroupBtnDelegate>

@end
@implementation Rice20SenseSizeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lengthTextField.tag = 1;
    self.widthTextField.tag = 2;
    self.sizeTextField.tag = 3;
    
    self.sharpenCheckBtn.tag = 5;
    self.sharpenTextField.tag = 6;
    self.mirrorCheckBtn.tag = 7;
    self.mirrorTextField.tag = 8;
    self.frontRearCheckbtn.tag = 9;
    self.groupBtnsView.tag = 10;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)MyTextFieldEditingDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:38 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:19 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
            NSInteger length =  self.lengthTextField.text.integerValue;
            NSInteger width = self.widthTextField.text.integerValue;
            [sender initKeyboardWithMax:length*width Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 6){
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 8){
        [sender initKeyboardWithMax:38 Min:0 Value:sender.text.integerValue];
    }
}

- (void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.integerValue];
}

- (IBAction)frontRearBtnChecked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.selected];
    if (sender.tag == 5) {
        if (sender.selected) {
            self.sharpenTextField.userInteractionEnabled = YES;
            self.sizeTextField.userInteractionEnabled = NO;
            self.sizeTextField.text= @"1";
            [super cellEditValueChangedWithTag:3 AndValue:1];
            [super cellEditValueChangedWithTag:6 AndValue:1];
            self.sharpenTextField.text = @"1";
        }else{
            self.sharpenTextField.userInteractionEnabled = NO;
            self.sizeTextField.userInteractionEnabled = YES;
        }
    }
    if (sender.tag == 7) {
        if (sender.selected) {
            self.mirrorTextField.userInteractionEnabled = YES;
        }else{
            self.mirrorTextField.userInteractionEnabled = NO;
        }
    }
    
}
-(void)updateGroupBtnHidden{
    self.groupBtnsView.delegate = self;
        if (self.groupNum<=1) {
            self.groupBtnsView.hidden = YES;
        }else{
            NSArray *arr = [NSArray array];
            for (int i = 0; i < self.groupNum; i++) {
                arr = [arr arrayByAddingObject:[NSString stringWithFormat:@"%@ %d",kLanguageForKey(372),i+1]];
            }
            if (self.groupBtnsView->groupNum != self.groupNum) {
                [self.groupBtnsView setGroupNum:self.groupNum Title:arr SelectedIndex:self.currentGroupIndex];
            }
            self.groupBtnsView.hidden = NO;
        }
}

-(void)updateSharpenHidden:(BOOL)hidden{
    self.sharpenCheckBtn.hidden = hidden;
    self.sharpenTextField.hidden = hidden;
    self.sharpenTitleLabel.hidden = hidden;
}

-(void)updateMirrorHidden:(BOOL)hidden{
    self.mirrorCheckBtn.hidden = hidden;
    self.mirrorTextField.hidden = hidden;
    self.mirrorTitleLabel.hidden = hidden;
}
- (void)groupBtnClicked:(Byte)index{
    [super cellEditValueChangedWithTag:self.groupBtnsView.tag AndValue:index];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateGroupBtnHidden];
}


@end
