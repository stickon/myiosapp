//
//  CaterpillarView.m
//  thColorSort
//
//  Created by huanghu on 2018/3/15.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "CaterpillarView.h"
@interface CaterpillarView()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentSpeedTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingSpeedTitleLabel;
@property (strong, nonatomic) IBOutlet UITextField *currentSpeedTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *settingTextField;
@property (strong, nonatomic) IBOutlet UIButton *CaterpillarSwitchBtn;
@property (assign, nonatomic) NSInteger settingSpeedMin;
@property (assign, nonatomic) NSInteger settingSpeedMax;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;

@end

static NSString *caterpillarTimer = @"Caterpillar";
@implementation CaterpillarView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"CaterpillarView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork]getCaterpillarSettingSpeed];
    return self;
}

- (void)initView{
   
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:caterpillarTimer
                                                           timeInterval:3.0
                                                                  queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf caterpillarTimerout];
                                                                 }];
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    [super initView];
    self.CaterpillarSwitchBtn.layer.cornerRadius = 3.0f;
    self.currentSpeedTextField.text = @"0";
    [self initLanguage];
    [self updateView];
}
-(void) initLanguage{
    self.currentSpeedTitleLabel.text = kLanguageForKey(143);
    self.settingSpeedTitleLabel.text = kLanguageForKey(144);
    [self.CaterpillarSwitchBtn setTitle:kLanguageForKey(134) forState:
     UIControlStateNormal];
    [self.CaterpillarSwitchBtn setTitle:kLanguageForKey(135) forState:UIControlStateSelected];
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    self.CaterpillarSwitchBtn.tintColor = [UIColor clearColor];
//    if (device->machineData.wheel[device.currentLayerIndex-1]) {
//        self.CaterpillarSwitchBtn.selected = true;
//        self.CaterpillarSwitchBtn.backgroundColor = [UIColor greenColor];
//        if (device.currentLayerIndex == 1) {
//            [self.CaterpillarSwitchBtn setTitle:kLanguageForKey(133) forState:UIControlStateSelected];
//        }else if (device.currentLayerIndex == 2){
//            [self.CaterpillarSwitchBtn setTitle:kLanguageForKey(135) forState:UIControlStateSelected];
//        }
//    }else{
//        if (device.currentLayerIndex == 1) {
//            [self.CaterpillarSwitchBtn setTitle:kLanguageForKey(132) forState:
//             UIControlStateNormal];
//        }else if (device.currentLayerIndex == 2){
//            [self.CaterpillarSwitchBtn setTitle:kLanguageForKey(134) forState:
//             UIControlStateNormal];
//        }
//        self.CaterpillarSwitchBtn.selected = false;
//        self.CaterpillarSwitchBtn.backgroundColor = [UIColor TaiheColor];
//    }
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* a = headerData.bytes;
    Device *device = kDataModel.currentDevice;
    if (a[0] == 0x0f) {
        if (a[1] == 0x01) {
            [self updateView];
            [[NetworkFactory sharedNetWork] getCaterpillarSpeed];
        }
        else if (a[1] == 0x02) {
            NSInteger currentSpeed = device->caterpillar.speed[0]*256+device->caterpillar.speed[1];
            self.currentSpeedTextField.text = [NSString stringWithFormat:@"%ld",(long)currentSpeed];
        }else if (a[1] == 0x04){
            self.settingSpeedMin = 500;
            self.settingTextField.text =[NSString stringWithFormat:@"%d",device->caterpillar.settingSpeedMin[0]*256+device->caterpillar.settingSpeedMin[1]];
            self.settingSpeedMax = device->caterpillar.settingSpeedMax[0]*256+device->caterpillar.settingSpeedMax[1];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork]getCaterpillarSettingSpeed];
    }
}
- (IBAction)switchBtnClicked:(UIButton *)sender {
    Device *device = kDataModel.currentDevice;
    sender.selected = !sender.selected;
    [[NetworkFactory sharedNetWork] switchCaterpillar:sender.selected withLayerIndex:device.currentLayerIndex];
}
- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:self.settingSpeedMax Min:self.settingSpeedMin Value:sender.text.integerValue];
}

- (void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Byte highByte = sender.text.integerValue/256;
    Byte lowByte =sender.text.integerValue%256;
//    [[NetworkFactory sharedNetWork] setCaterpillarSpeedByte1:highByte byte2:lowByte];
}

- (void)caterpillarTimerout{
    [[NetworkFactory sharedNetWork] getCaterpillarSpeed];
}

-(BOOL)Back{
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:caterpillarTimer];
    return [super Back];
}

-(void)networkError:(NSError *)error{
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:caterpillarTimer];
    [super networkError:error];
}
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self updateView];
}


@end
