//
//  TableViewCellRebuild.m
//  thColorSort
//
//  Created by huanghu on 2018/9/21.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "TableViewCellRebuild.h"
#import "BaseUITextField.h"

@interface TableViewCellRebuild()<MyTextFieldDelegate>
@property(nonatomic,assign) NSInteger min;
@property(nonatomic,assign) NSInteger max;
@end

@implementation TableViewCellRebuild

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    NSInteger value = sender.text.intValue;
    [super cellEditValueChangedWithTag:sender.tag AndValue:value];
}
- (IBAction)MytextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:self.max Min:self.min Value:sender.text.integerValue];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.useBtn.tag = 0;
    self.itemSenseTextField.tag = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTextFieldMin:(NSInteger)min Max:(NSInteger)max{
    self.min = min;
    self.max = max;
}

- (IBAction)btnUseChecked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.selected];
}

@end
