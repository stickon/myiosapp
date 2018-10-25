//
//  WaveDataTableViewCell.m
//  thColorSort
//
//  Created by huanghuMacos on 2017/3/27.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "WaveDataTableViewCell.h"
@interface WaveDataTableViewCell()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *minusBtn;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn;
@end
@implementation WaveDataTableViewCell

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.integerValue];
}
- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:self.chuteNumCount Min:1 Value:sender.text.integerValue];
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (sender == self.minusBtn) {
        [super cellEditValueChangedWithTag:sender.tag AndValue:1 bSend:YES];
    }else if (sender == self.plusBtn){
        [super cellEditValueChangedWithTag:sender.tag AndValue:2 bSend:YES];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat width =[UIScreen mainScreen].bounds.size.width-40;
    CGFloat height = (width-40)*0.618+20;
    self.waveDataView.frame = CGRectMake(3, 10, width,height);
    self.chuteTextField.text = @"1";
    self.chuteTitleLabel.textColor = [UIColor TaiheColor];
    [self.waveDataView initGridView];
    self.minusBtn.tag = 1;
    self.plusBtn.tag = 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)bindWaveData:(Byte*)wavedata withIndex:(Byte)index
{
    [_waveDataView bindWaveData:wavedata withIndex:index];
}

-(void)bindWaveColorType:(Byte*)wavetype andColorDiffLightType:(Byte)colorDiffLightType andAlgriothmType:(Byte)alogriothmtype
{
    [_waveDataView bindWaveColorType:wavetype andColorDiffLightType:colorDiffLightType andAlgriothmType:alogriothmtype];
    [_waveDataView displayView];
}

-(void)bindWaveDataType:(Byte)type irUseType:(Byte)irType WaveCount:(Byte)count{
    [self.waveDataView bindWaveDataType:type irUseType:irType WaveCount:count];
    [self.waveDataView displayView];
}

@end
