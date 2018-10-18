//
//  RiceLengthView.m
//  thColorSort
//
//  Created by huanghu on 2018/2/27.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "RiceLengthView.h"
@interface RiceLengthView()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *FirstTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *SecondTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ThirdTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *FourthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *FirstSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *SecondSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *ThirdSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *FourthTextField;
@property (strong, nonatomic) IBOutlet UIButton *useBtn;
@property (strong, nonatomic) NSArray *titleLabelArray;
@property (strong, nonatomic) NSArray *senseTextFieldArray;
@end
@implementation RiceLengthView
-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"RiceLengthView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] getLengthRice];
    return self;
}

-(void)initView{
    self.titleLabelArray = @[self.FirstTitleLabel,self.SecondTitleLabel,self.ThirdTitleLabel,self.FourthTitleLabel];
    self.senseTextFieldArray = @[self.FirstSenseTextField,self.SecondSenseTextField,self.ThirdSenseTextField,self.FourthTextField];
    self.FirstSenseTextField.tag = 1;
    self.SecondSenseTextField.tag = 2;
    self.ThirdSenseTextField.tag = 3;
    self.FourthTextField.tag = 4;
    self.useBtn.layer.cornerRadius = 3.0f;
    [self.useBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.useBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.useBtn.tintColor = [UIColor clearColor];
    [self initLanguage];
}

-(void)initLanguage{
    self.FirstTitleLabel.text = kLanguageForKey(331);
    self.SecondTitleLabel.text = kLanguageForKey(332);
    self.ThirdTitleLabel.text = kLanguageForKey(401);
    self.FourthTitleLabel.text = kLanguageForKey(402);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x20) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getLengthRice];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
  
    for (int i = 0; i < 4; i++) {
        if (i<device->groupNum) {
            [self.titleLabelArray[i] setHidden:NO];
            [self.senseTextFieldArray[i] setHidden:NO];
            BaseUITextField *textField = self.senseTextFieldArray[i];
            textField.text = [NSString stringWithFormat:@"%d",device->lengthRice.textView[i]];
        }else{
            [self.titleLabelArray[i] setHidden:YES];
            [self.senseTextFieldArray[i] setHidden:YES];
        }
    }
    if (device->lengthRice.buttonUse) {
        self.useBtn.selected = true;
        self.useBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.useBtn.selected = false;
        self.useBtn.backgroundColor = [UIColor TaiheColor];
    }
}

- (IBAction)useBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setLengthRiceUseState:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setLengthRiceUseState:0];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setLengthRiceSenseWithGroup:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getTea];
}

@end
