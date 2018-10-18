//
//  RiceBrokenView.m
//  thColorSort
//
//  Created by huanghu on 2018/2/27.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "RiceBrokenView.h"
@interface RiceBrokenView()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *FirstTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *SecondTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ThirdTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *FourthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *limitTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *FirstSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *SecondSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *ThirdSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *FourthSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *FirstLimitTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *SecondLimitTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *ThirdLimitTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *FourthLimitTextField;
@property (strong, nonatomic) IBOutlet UIButton *useBtn;
@property (strong, nonatomic) NSArray *titleLabelArray;
@property (strong, nonatomic) NSArray *senseTextFieldArray;
@property (strong, nonatomic) NSArray *limitTextFieldArray;
@end
@implementation RiceBrokenView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"RiceBrokenView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] getBrokenRice];
    return self;
}

-(void)initView{
    self.titleLabelArray = @[self.FirstTitleLabel,self.SecondTitleLabel,self.ThirdTitleLabel,self.FourthTitleLabel];
    self.senseTextFieldArray = @[self.FirstSenseTextField,self.SecondSenseTextField,self.ThirdSenseTextField,self.FourthSenseTextField];
    self.limitTextFieldArray = @[self.FirstLimitTextField,self.SecondLimitTextField,self.ThirdLimitTextField,self.FourthLimitTextField];
    
    self.FirstSenseTextField.tag = 1;
    self.SecondSenseTextField.tag = 2;
    self.ThirdSenseTextField.tag = 3;
    self.FourthSenseTextField.tag = 4;
    
    self.FirstLimitTextField.tag = 5;
    self.SecondLimitTextField.tag = 6;
    self.ThirdLimitTextField.tag = 7;
    self.FourthLimitTextField.tag = 8;
    
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
    self.senseTitleLabel.text = kLanguageForKey(14);
    self.limitTitleLabel.text = kLanguageForKey(275);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x21) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getBrokenRice];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    
    for (int i = 0; i < 4; i++) {
        if (i<device->groupNum) {
            [self.titleLabelArray[i] setHidden:NO];
            [self.senseTextFieldArray[i] setHidden:NO];
            [self.limitTextFieldArray[i] setHidden:NO];
            BaseUITextField *textField = self.senseTextFieldArray[i];
            textField.text = [NSString stringWithFormat:@"%d",device->brokenRice.textView[i]];
            BaseUITextField *limitTextField = self.limitTextFieldArray[i];
            limitTextField.text = [NSString stringWithFormat:@"%d",device->brokenRice.text2View[i][0]*256+device->brokenRice.text2View[i][1]];
        }else{
            [self.titleLabelArray[i] setHidden:YES];
            [self.senseTextFieldArray[i] setHidden:YES];
            [self.limitTextFieldArray[i] setHidden:YES];
        }
    }
    if (device->brokenRice.buttonUse) {
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
        [[NetworkFactory sharedNetWork] setBrokenRiceUseState:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setBrokenRiceUseState:0];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag < 5) {
        BaseUITextField *limitTextField = self.limitTextFieldArray[sender.tag-1];
        if (limitTextField.text.integerValue < 128) {
             [sender initKeyboardWithMax:limitTextField.text.integerValue Min:1 Value:sender.text.integerValue];
        }else{
             [sender initKeyboardWithMax:128 Min:1 Value:sender.text.integerValue];
        }
       
    }else{
        BaseUITextField *senseTextField = self.senseTextFieldArray[sender.tag-5];
    [sender initKeyboardWithMax:1024 Min:senseTextField.text.integerValue Value:sender.text.integerValue];
    }
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setBrokenRiceSenseWithIndex:sender.tag Value:sender.text.integerValue];
}

@end
