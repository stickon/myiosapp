//
//  SingleViewSvm.m
//  thColorSort
//
//  Created by 黄虎 on 2018/10/30.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SingleViewSvm.h"
#import "BaseUITextField.h"
#import "types.h"
#import "NetworkFactory.h"
@interface SingleViewSvm()<MyTextFieldDelegate>{
    SvmInfo svmInfo;
    NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
@property (strong, nonatomic) IBOutlet UIButton *useBtn;
@property (strong, nonatomic) IBOutlet UILabel *impurityTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseValueTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *viewTitle;
@property (strong, nonatomic) IBOutlet BaseUITextField *impurityEdit;
@property (strong, nonatomic) IBOutlet BaseUITextField *senseEdit;
@property (strong, nonatomic) IBOutlet UIButton *minus1;
@property (strong, nonatomic) IBOutlet UIButton *minus2;
@property (strong, nonatomic) IBOutlet UIButton *plus1;
@property (strong, nonatomic) IBOutlet UIButton *plus2;

@end
@implementation SingleViewSvm

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SingleViewSvm" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    
    return self;
}
-(void)initView{
        self.impurityTitleLabel.text = kLanguageForKey(184);
    self.impurityEdit.tag = 2;
    self.senseEdit.tag = 3;
    self.useBtn.tag = 0;
    self.rejectBtn.tag = 1;
    self.useBtn.tintColor = [UIColor clearColor];
    self.rejectBtn.tintColor = [UIColor clearColor];
        self.senseValueTitleLabel.text = kLanguageForKey(14);
        [self.rejectBtn setTitle:kLanguageForKey(183) forState:UIControlStateNormal];
        [self.rejectBtn setTitle:kLanguageForKey(182) forState:UIControlStateSelected];
        [self.useBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
        [self.useBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.minus1.tag = 4;
    self.plus1.tag = 5;
    self.minus2.tag = 6;
    self.plus2.tag = 7;
    self.rejectBtn.layer.cornerRadius = 3.0f;
    self.useBtn.layer.cornerRadius = 3.0f;
    
    UILongPressGestureRecognizer *minis1longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPress:)];
    UILongPressGestureRecognizer *plus1longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPress:)];
    UILongPressGestureRecognizer *minis2longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPress:)];
    UILongPressGestureRecognizer *plus2longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPress:)];
    [self.minus1 addGestureRecognizer:minis1longPress];
    [self.plus1 addGestureRecognizer:plus1longPress];
    [self.minus2 addGestureRecognizer:minis2longPress];
    [self.plus2 addGestureRecognizer:plus2longPress];

}

static int valueTmp = 0;
-(void)buttonLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    UIButton *btn = (UIButton*)gestureRecognizer.view;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        valueTmp=0;
        __weak typeof(self) weakself = self;
        timer=[NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"%d",++valueTmp);
            if (btn.tag == 4) {
                
                int value = weakself.impurityEdit.text.intValue;
                if (value > 0) {
                    value--;
                }
                weakself.impurityEdit.text = [NSString stringWithFormat:@"%d",value];
            }else if (btn.tag == 5){
                int value = weakself.impurityEdit.text.intValue;
                if (value < self->svmInfo.spotDiffMax[0]*256+self->svmInfo.spotDiffMax[1]) {
                    value++;
                }
                weakself.impurityEdit.text = [NSString stringWithFormat:@"%d",value];
            }else if (btn.tag == 6){
                int value = weakself.senseEdit.text.intValue;
                if (value > 0) {
                    value--;
                }
                weakself.senseEdit.text = [NSString stringWithFormat:@"%d",value];
            }else if (btn.tag == 7){
                int value = weakself.senseEdit.text.intValue;
                if (value < 100) {
                    value++;
                }
                weakself.senseEdit.text = [NSString stringWithFormat:@"%d",value];
            }
        }];
       
    }else{
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            return;
        }
        
        if(timer!=nil){
            [timer invalidate];
            timer=nil;
            Device *device = kDataModel.currentDevice;
            if (btn.tag == 4 || btn.tag == 5) {
                [gNetwork setSvmInfoWithGroup:device.currentGroupIndex View:svmInfo.view Type:2 Value:self.impurityEdit.text.integerValue];
            }else if (btn.tag == 6 || btn.tag == 7){
                [gNetwork setSvmInfoWithGroup:device.currentGroupIndex View:svmInfo.view Type:3 Value:self.senseEdit.text.integerValue];
            }
            NSLog(@"result %d",valueTmp);
        }
    }
}
-(void)updateViewWithData:(SvmInfo*)svminfo{
    memcpy(&svmInfo, svminfo, sizeof(SvmInfo));
    if (svmInfo.view) {
        self.viewTitle.text = kLanguageForKey(76);
    }else{
        self.viewTitle.text = kLanguageForKey(75);
    }
    self.rejectBtn.selected = svmInfo.blowSample;
    if (svmInfo.blowSample) {
        self.rejectBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.rejectBtn.backgroundColor = [UIColor NormalColor];
    }
    self.useBtn.selected = svmInfo.used;
    if (svmInfo.used) {
        self.useBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.useBtn.backgroundColor = [UIColor NormalColor];
    }
    self.impurityEdit.text = [NSString stringWithFormat:@"%d",svmInfo.spotDiff[0]*256+svmInfo.spotDiff[1]];
    self.senseEdit.text = [NSString stringWithFormat:@"%d",svmInfo.spotSensor];

}
- (IBAction)editDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender == self.impurityEdit) {
       [self.impurityEdit initKeyboardWithMax:svmInfo.spotDiffMax[0]*256+svmInfo.spotDiffMax[1] Min:0 Value:sender.text.integerValue];
    }else if (sender == self.senseEdit){
        [sender initKeyboardWithMax:100 Min:1 Value:sender.text.integerValue];
    }
}

-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Device *device = kDataModel.currentDevice;
    [gNetwork setSvmInfoWithGroup:device.currentGroupIndex View:svmInfo.view Type:sender.tag Value:sender.text.integerValue];
    
}
- (IBAction)singleClicked:(UIButton *)sender {
    int value = 0;
    if (sender.tag == 4) {
       value = self.impurityEdit.text.intValue;
        if (value > 0) {
            value--;
        }
        self.impurityEdit.text = [NSString stringWithFormat:@"%d",value];
    }else if (sender.tag == 5){
        value = self.impurityEdit.text.intValue;
        if (value < self->svmInfo.spotDiffMax[0]*256+self->svmInfo.spotDiffMax[1]) {
            value++;
        }
        self.impurityEdit.text = [NSString stringWithFormat:@"%d",value];
    }else if (sender.tag == 6){
        value = self.senseEdit.text.intValue;
        if (value > 0) {
            value--;
        }
        self.senseEdit.text = [NSString stringWithFormat:@"%d",value];
    }else if (sender.tag == 7){
       value = self.senseEdit.text.intValue;
        if (value < 100) {
            value++;
        }
        self.senseEdit.text = [NSString stringWithFormat:@"%d",value];
    }
    Device *device = kDataModel.currentDevice;
    if (sender.tag == 4 || sender.tag == 5) {
        [gNetwork setSvmInfoWithGroup:device.currentGroupIndex View:svmInfo.view Type:2 Value:value];
    }else if (sender.tag == 6 || sender.tag == 7){
        [gNetwork setSvmInfoWithGroup:device.currentGroupIndex View:svmInfo.view Type:3 Value:value];
    }
}
- (IBAction)btnClicked:(UIButton *)sender {
    Device *device = kDataModel.currentDevice;
    [gNetwork setSvmInfoWithGroup:device.currentGroupIndex View:svmInfo.view Type:sender.tag Value:0];
}
@end
