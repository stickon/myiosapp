//
//  SvmGroup31View.m
//  thColorSort
//
//  Created by huanghu on 2018/1/17.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "SvmGroup31View.h"
#import "MyGroupView.h"
const int kMaxGroupNum = 4;
@interface SvmGroup31View ()<MyTextFieldDelegate,GroupBtnDelegate>
@property (strong, nonatomic) IBOutlet UIButton *UseBtn;
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
@property (strong, nonatomic) IBOutlet UIButton *frontViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearViewBtn;

@property (strong, nonatomic) IBOutlet UILabel *impurityTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseValueTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *impurityTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *senseValueTextField;
@property (strong, nonatomic) IBOutlet MyGroupView *groupBtnsView;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@end

@implementation SvmGroup31View

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SvmGroup31View" owner:self options:nil] firstObject];
        Device *device = kDataModel.currentDevice;
        if (device->machineData.layerNumber>1) {
            self.baseLayerLabel = self.currentLayerLabel;
        }else{
            self.currentLayerLabel.frame = CGRectZero;
            self.currentLayerLabelHeightConstraint.constant = 0.0f;
        }
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self initView];
    [[NetworkFactory sharedNetWork] getSvmPara];
    return self;
}


-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char *a = headerData.bytes;
    if (a[0] == 0x10) {
        [self updateView];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getSvmPara];
    }
}

-(void)initView{
    [super initView];
    self.rejectBtn.layer.cornerRadius = 3.0f;
    self.UseBtn.layer.cornerRadius = 3.0f;
    self.rejectBtn.tintColor = [UIColor clearColor];
    self.UseBtn.tintColor = [UIColor clearColor];
    self->viewBtn[0] = self.frontViewBtn;
    self->viewBtn[1] = self.rearViewBtn;
    [super frontRearViewBtnAddTargetEvent];
    self.groupBtnsView.delegate = self;
    
    [self initLanguage];
}
-(void)updateView{
    Device *device = kDataModel.currentDevice;
    if (device.currentViewIndex == 0) {
        self.frontViewBtn.userInteractionEnabled = NO;
        self.rearViewBtn.userInteractionEnabled = YES;
        self.frontViewBtn.backgroundColor = [UIColor greenColor];
        self.rearViewBtn.backgroundColor = [UIColor TaiheColor];
    }else if (device.currentViewIndex == 1){
        self.frontViewBtn.userInteractionEnabled = YES;
        self.rearViewBtn.userInteractionEnabled = NO;
        self.rearViewBtn.backgroundColor = [UIColor greenColor];
        self.frontViewBtn.backgroundColor = [UIColor TaiheColor];
    }
    self.impurityTextField.text = [NSString stringWithFormat:@"%d",device->svm.spotDiff_1[0]*256+device->svm.spotDiff_1[1]];
    self.senseValueTextField.text = [NSString stringWithFormat:@"%d",device->svm.sensor_1];
    if (device->svm.used) {
        self.UseBtn.selected = true;
        self.UseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.UseBtn.selected = false;
        self.UseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->svm.blowSample) {
        self.rejectBtn.selected = true;
        self.rejectBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.rejectBtn.selected = false;
        self.rejectBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
        self.rearViewBtn.hidden = NO;
    }else{
        self.rearViewBtn.hidden = YES;
    }
    [self updateGroupBtnHidden];
}
-(void)updateGroupBtnHidden{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
    }else{
        if (device.svmGroupNum<=1) {
            self.groupBtnsView.hidden = YES;
        }else{
            NSArray *arr = [NSArray array];
            for (int i = 0; i < device.svmGroupNum; i++) {
                arr = [arr arrayByAddingObject:[NSString stringWithFormat:@"%@ %d",kLanguageForKey(372),i+1]];
            }
            if (self.groupBtnsView->groupNum != device.svmGroupNum) {
                [self.groupBtnsView setGroupNum:device.svmGroupNum Title:arr SelectedIndex:0];
            }
            
            self.groupBtnsView.hidden = NO;
            
        }
    }
}


-(void)initLanguage{
    
    [self.frontViewBtn setTitle:kLanguageForKey(75) forState:UIControlStateNormal];
    [self.rearViewBtn setTitle:kLanguageForKey(76) forState:UIControlStateNormal];
    self.impurityTitleLabel.text = kLanguageForKey(184);
    self.senseValueTitleLabel.text = kLanguageForKey(14);
    [self.rejectBtn setTitle:kLanguageForKey(183) forState:UIControlStateNormal];
    [self.rejectBtn setTitle:kLanguageForKey(182) forState:UIControlStateSelected];
    [self.UseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.UseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.title =  kLanguageForKey(31);
    
}
#pragma mark GroupBtnDelegate
- (void)groupBtnClicked:(Byte)index{
    Device *device = kDataModel.currentDevice;
    device.currentGroupIndex = index;
    [[NetworkFactory sharedNetWork] getSvmPara];
}

- (IBAction)rejectBtnClicked:(UIButton *)sender {
    [[NetworkFactory sharedNetWork] setSvmParaWithType:6 AndData:!sender.selected];
    
}
- (IBAction)useBtnClicked:(UIButton *)sender {
    Device *device = kDataModel.currentDevice;
    [[NetworkFactory sharedNetWork] setSvmParaWithType:device.currentViewIndex AndData:!sender.selected];
}

- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    Device *device = kDataModel.currentDevice;
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 2) {
        if(device->svmIsProportion){
            [sender initKeyboardWithMax:100 Min:1 Value:sender.text.integerValue];
        }else{
            [sender initKeyboardWithMax:493 Min:1 Value:sender.text.integerValue];
        }
    }else if(sender.tag == 3){
        [sender initKeyboardWithMax:100 Min:0 Value:sender.text.integerValue];
    }
    
}
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Device *device = kDataModel.currentDevice;
    if (device.currentViewIndex) {
        if(sender.tag == 2){
            [[NetworkFactory sharedNetWork] setSvmParaWithType:4 AndData:sender.text.integerValue];
        }
        else if(sender.tag == 3){
            [[NetworkFactory sharedNetWork] setSvmParaWithType:5 AndData:sender.text.integerValue];
        }
    }else{
        if(sender.tag == 2){
            [[NetworkFactory sharedNetWork] setSvmParaWithType:2 AndData:sender.text.integerValue];
        }else if (sender.tag == 3){
            [[NetworkFactory sharedNetWork] setSvmParaWithType:3 AndData:sender.text.integerValue];
        }
    }
}

-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self updateView];
    [[NetworkFactory sharedNetWork] getSvmPara];
}

- (void)frontRearViewChanged{
    [[NetworkFactory sharedNetWork] getSvmPara];
}

@end
