//
//  CalibrationView.m
//  thColorSort
//
//  Created by huanghu on 2018/1/15.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "CalibrationView.h"
#import "JX_GCDTimerManager.h"
#import "WaveDataView.h"
#import "TipsView.h"

@interface CalibrationView()<MyTextFieldDelegate,TipsViewResultDelegate>
{
    Byte calibrationType;//校准方式 初始化0
}
@property (strong, nonatomic) TipsView *tipsView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet WaveDataView *waveView;
@property (strong, nonatomic) IBOutlet UIButton *cameraSetRadioBtn;
@property (strong, nonatomic) IBOutlet UILabel *chuteTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *chuteNumTextField;
@property (strong, nonatomic) IBOutlet UIButton *detailDataRadioBtn;
@property (strong, nonatomic) IBOutlet UIButton *compressDataRadioBtn;
@property (strong, nonatomic) IBOutlet UILabel *cameraSetTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailDataTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *compressDataTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *originDataBtn;
@property (strong, nonatomic) IBOutlet UIButton *calibrationDataBtn;
@property (strong, nonatomic) IBOutlet UIButton *testDataBtn;
@property (strong, nonatomic) IBOutlet UIButton *frontViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearViewBtn;
@property (assign, nonatomic) WaveDataType waveType;//波形的类形  08: 原始数据09: 校正数据  0a：测试数据

@property (assign, nonatomic) Byte dataType;//数据类型   0：详细数据 1：压缩数据  2：相机调整
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (assign, nonatomic) Byte position;
@property (nonatomic,assign) Byte timerSuspend;//1 挂起 0运行
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@end
static NSString *waveTimer = @"calibrationWaveTimer";
@implementation CalibrationView


-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"CalibrationView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        
    }
    
    return self;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self setChildViewState];
    self.waveType = wave_origin;
    [[NetworkFactory sharedNetWork] changeWaveDataWithType:0];
    [self startGetWave];
    
    calibrationType= 0;
    return self;
}


-(void)initView{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    [super initView];
    [self initLanguage];
    self->viewBtn[0] = self.frontViewBtn;
    self->viewBtn[1] = self.rearViewBtn;
    [super frontRearViewBtnAddTargetEvent];
    self.cameraSetRadioBtn.selected = false;
    self.cameraSetRadioBtn.userInteractionEnabled = true;
    
    self.detailDataRadioBtn.selected = true;
    self.detailDataRadioBtn.userInteractionEnabled = false;
    self.compressDataRadioBtn.selected = false;
    self.compressDataRadioBtn.userInteractionEnabled = true;
    self.cameraSetRadioBtn.tag = 1;
    self.detailDataRadioBtn.tag = 2;
    self.compressDataRadioBtn.tag = 3;
    self.originDataBtn.backgroundColor = [UIColor greenColor];
    self.originDataBtn.userInteractionEnabled = false;
    self.dataType = 0;
    self.originDataBtn.layer.cornerRadius = 3.0f;
    self.calibrationDataBtn.layer.cornerRadius = 3.0f;
    self.testDataBtn.layer.cornerRadius = 3.0f;
    self.originDataBtn.tag = 10;
    self.calibrationDataBtn.tag = 11;
    self.testDataBtn.tag = 12;
    
    self.calibrationDataBtn.backgroundColor = [UIColor TaiheColor];
    self.testDataBtn.backgroundColor = [UIColor TaiheColor];
    
    if (device.currentViewIndex == 0) {
        self.frontViewBtn.backgroundColor = [UIColor greenColor];
        self.rearViewBtn.backgroundColor = [UIColor TaiheColor];
        self.frontViewBtn.userInteractionEnabled = false;
        self.rearViewBtn.userInteractionEnabled = true;
    }else{
        self.frontViewBtn.backgroundColor = [UIColor TaiheColor];
        self.rearViewBtn.backgroundColor = [UIColor greenColor];
        self.rearViewBtn.userInteractionEnabled = false;
        self.frontViewBtn.userInteractionEnabled = true;
    }
    self.chuteNumTextField.text = [NSString stringWithFormat:@"%d",device.currentSorterIndex];
    [[NetworkFactory sharedNetWork] getCalibrationPara];
}
-(void)dealloc{
    NSLog(@"setting view dealloc");
}

- (void)setChildViewState{
    Device *device = kDataModel.currentDevice;
    bool enable = NO;
    if(device->machineData.startState!=1){
        enable = YES;
    }
   
}
- (void)initLanguage
{
    self.chuteTitleLabel.text = kLanguageForKey(41);
    [self.frontViewBtn setTitle:kLanguageForKey(75) forState:UIControlStateNormal];
    [self.rearViewBtn setTitle:kLanguageForKey(76) forState:     UIControlStateNormal];
    self.cameraSetTitleLabel.text = kLanguageForKey(187);
    self.detailDataTitleLabel.text = kLanguageForKey(188);
    self.compressDataTitleLabel.text = kLanguageForKey(189);
   
    [self.originDataBtn setTitle:kLanguageForKey(192) forState:UIControlStateNormal];
    [self.calibrationDataBtn setTitle:kLanguageForKey(193) forState:UIControlStateNormal];
    [self.testDataBtn setTitle:kLanguageForKey(194) forState:UIControlStateNormal];
    self.title = kLanguageForKey(174);
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.position = sender.value;
}
- (IBAction)radioBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        self.cameraSetRadioBtn.selected = true;
        self.cameraSetRadioBtn.userInteractionEnabled = false;
        self.detailDataRadioBtn.selected = false;
        self.detailDataRadioBtn.userInteractionEnabled = true;
        self.compressDataRadioBtn.selected = false;
        self.compressDataRadioBtn.userInteractionEnabled = true;
        self.dataType = 2;
        [self.slider setHidden:true];
    }else if (sender.tag == 2){
        self.cameraSetRadioBtn.selected = false;
        self.cameraSetRadioBtn.userInteractionEnabled = true;
        self.detailDataRadioBtn.selected = true;
        self.detailDataRadioBtn.userInteractionEnabled = false;
        self.compressDataRadioBtn.selected = false;
        self.compressDataRadioBtn.userInteractionEnabled = true;
        self.dataType = 0;
        [self.slider setHidden:false];
    }else if (sender.tag == 3){
        self.cameraSetRadioBtn.selected = false;
        self.cameraSetRadioBtn.userInteractionEnabled = true;
        self.detailDataRadioBtn.selected = false;
        self.detailDataRadioBtn.userInteractionEnabled = true;
        self.compressDataRadioBtn.selected = true;
        self.compressDataRadioBtn.userInteractionEnabled = false;
        self.dataType = 1;
        [self.slider setHidden:true];
    }
}

- (IBAction)changeWaveBtnClicked:(UIButton *)sender {
    if (sender.tag == 10) {
        self.waveType = wave_origin;
        self.originDataBtn.backgroundColor = [UIColor greenColor];
        self.calibrationDataBtn.backgroundColor = [UIColor TaiheColor];
        self.testDataBtn.backgroundColor = [UIColor TaiheColor];
        self.originDataBtn.userInteractionEnabled = false;
        self.calibrationDataBtn.userInteractionEnabled = true;
        self.testDataBtn.userInteractionEnabled = true;
    }else if (sender.tag == 11){
        self.waveType = wave_calibration;
        self.originDataBtn.backgroundColor = [UIColor TaiheColor];
        self.calibrationDataBtn.backgroundColor = [UIColor greenColor];
        self.testDataBtn.backgroundColor = [UIColor TaiheColor];
        self.originDataBtn.userInteractionEnabled = true;
        self.calibrationDataBtn.userInteractionEnabled = false;
        self.testDataBtn.userInteractionEnabled = true;;
    }else if (sender.tag == 12){
        self.waveType = wave_test_data;
        self.originDataBtn.backgroundColor = [UIColor TaiheColor];
        self.calibrationDataBtn.backgroundColor = [UIColor TaiheColor];
        self.testDataBtn.backgroundColor = [UIColor greenColor];
        self.originDataBtn.userInteractionEnabled = true;
        self.calibrationDataBtn.userInteractionEnabled = true;
        self.testDataBtn.userInteractionEnabled = false;
    }
    [[NetworkFactory sharedNetWork] changeWaveDataWithType:(sender.tag)%10];
}

-(void)updateViewData{
    Device *device = kDataModel.currentDevice;
    
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char*a = headerData.bytes;
    if (a[0] == 0x11) {
        if (a[1] == 0x01) {
            [self updateViewData];
            
        }else if (a[1] == 0x03){
            switch (a[2]) {
                case 0:
                    [self makeToast:kLanguageForKey(199) duration:2.0 position:CSToastPositionCenter];
                    break;
                case 1:
                    [self makeToast:kLanguageForKey(200) duration:2.0 position:CSToastPositionCenter];
                    break;
                case 2:
                {
                    NSString *errorStr = [NSString stringWithFormat:@"%@%@%@",kLanguageForKey(199),kLanguageForKey(75),kLanguageForKey(201)];
                    [self makeToast:errorStr duration:2.0 position:CSToastPositionCenter];
                }
                    break;
                case 3:
                {
                    NSString *errorStr = [NSString stringWithFormat:@"%@%@%@",kLanguageForKey(199),kLanguageForKey(75),kLanguageForKey(202)];
                    [self makeToast:errorStr duration:2.0 position:CSToastPositionCenter];
                }
                    break;
                case 4:
                {
                    NSString *errorStr = [NSString stringWithFormat:@"%@%@%@",kLanguageForKey(199),kLanguageForKey(75),kLanguageForKey(203)];
                    [self makeToast:errorStr duration:2.0 position:CSToastPositionCenter];
                }
                    break;
                case 5:
                {
                    NSString *errorStr = [NSString stringWithFormat:@"%@%@%@",kLanguageForKey(199),kLanguageForKey(75),kLanguageForKey(204)];
                    [self makeToast:errorStr duration:2.0 position:CSToastPositionCenter];
                }
                    break;
                case 6:
                {
                    NSString *errorStr = [NSString stringWithFormat:@"%@%@%@",kLanguageForKey(199),kLanguageForKey(76),kLanguageForKey(201)];
                    [self makeToast:errorStr duration:2.0 position:CSToastPositionCenter];
                }
                    break;
                case 7:
                {
                    NSString *errorStr = [NSString stringWithFormat:@"%@%@%@",kLanguageForKey(199),kLanguageForKey(76),kLanguageForKey(202)];
                    [self makeToast:errorStr duration:2.0 position:CSToastPositionCenter];
                }
                    break;
                case 8:
                {
                    NSString *errorStr = [NSString stringWithFormat:@"%@%@%@",kLanguageForKey(199),kLanguageForKey(76),kLanguageForKey(203)];
                    [self makeToast:errorStr duration:2.0 position:CSToastPositionCenter];
                }
                    break;
                case 9:
                {
                    NSString *errorStr = [NSString stringWithFormat:@"%@%@%@",kLanguageForKey(199),kLanguageForKey(76),kLanguageForKey(204)];
                    [self makeToast:errorStr duration:2.0 position:CSToastPositionCenter];
                }
                    break;
                default:
                    break;
            }
            if (self.timerSuspend) {
                [self resumeTimer];
            }
        }
    }else if (a[0] == 0x0b){
        Device *device = kDataModel.currentDevice;
        self.waveView.irUseType = device->machineData.useIR;
        [self.waveView setWaveDataType:a[1]];
        self.waveView.waveDataCount = device->waveDataCount;
        for (int i =0;i<device->waveDataCount; i++) {
            [self.waveView bindCalibrationWaveData:device->calibrationWaveData[i] withIndex:i];
        }
        self.waveView.dataType  = self.dataType;
        [self.waveView displayView];
    }else if (a[0] == 0x03 && a[1] == 0x03){
        [self setChildViewState];
    }else if (a[0] == 0x55){
        [self stopTimer];
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork] changeWaveDataWithType:0];
    }
}
- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    Device *device = kDataModel.currentDevice;
    if (sender.tag == 4) {
        [sender initKeyboardWithMax:255 Min:35 Value:sender.text.integerValue];
    }else if (sender.tag == 5){
        [sender initKeyboardWithMax:100 Min:5 Value:sender.text.integerValue];
    }else if (sender.tag == 6){
        [sender initKeyboardWithMax:device->machineData.chuteNumber Min:1 Value:sender.text.integerValue];
    }
}

- (void)mytextfieldDidEnd:(BaseUITextField *)sender{
    Device *device = kDataModel.currentDevice;
    if (sender.tag == 4) {
        device->waveAvgData = sender.text.integerValue;
        [[NetworkFactory sharedNetWork] setCalibrationParaWithType:0 Data:sender.text.integerValue];
    }else if (sender.tag == 5){
        device->waveDiffData = sender.text.integerValue;
        [[NetworkFactory sharedNetWork] setCalibrationParaWithType:1 Data:sender.text.integerValue];
    }else if (sender.tag == 6){
        device.currentSorterIndex = sender.text.integerValue;
        [[NetworkFactory sharedNetWork] getCalibrationPara];
    }
}
#pragma mark 处理波形
-(void)startGetWave{
    self.timerSuspend = 0;
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:waveTimer
                                                           timeInterval:0.8
                                                                  queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf waveTimerOut];
                                                                 }];
}

-(void)waveTimerOut{
    Device *device = kDataModel.currentDevice;
    waveTypeCalibration wavetype;
    wavetype.Algorithm = 0;
    wavetype.layer = device.currentLayerIndex-1;
    wavetype.view = device.currentViewIndex;
    wavetype.ch = device.currentSorterIndex-1;
    wavetype.waveType = self.waveType;
    wavetype.dataType = self.dataType;
    wavetype.postion = self.position;
    [gNetwork sendToGetCalibrationWave:&wavetype Type:wave_calibration];
    
}
-(void)pauseTimer{
    self.timerSuspend = 1;
    [[JX_GCDTimerManager sharedInstance] pauseTimerWithName:waveTimer];
}
-(void)resumeTimer{
    self.timerSuspend = 0;
    [[JX_GCDTimerManager sharedInstance] resumeTimerWithName:waveTimer];
}
-(void)stopTimer{
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:waveTimer];
}
#pragma mark 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentViewHeightConstraint.constant = self.waveView.frame.size.height + 385.5;
    [self.waveView setNeedsLayout];
}

#pragma mark -baseviewcontroller
- (void)networkError:error{
    [self stopTimer];
    [super networkError:error];
}
-(void)socketSendError{
    [self stopTimer];
    [super socketSendError];
}

-(BOOL)Back{
    //Fix 设置成原始数据
    self.waveType = wave_origin;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NetworkFactory sharedNetWork] changeWaveDataWithType:0];
    [self stopTimer];
    return [super Back];
}
#pragma mark tipsviewDelegate
-(void)tipsViewResult:(Byte)value{
    if (value) {
        if (calibrationType != 3) {
            [self pauseTimer];
//            [self setCalibrationBtnUserInterfaceEnbled:NO];//防止由于tcp连接时状态返回较慢导致多次点击
        }
        
        [[NetworkFactory sharedNetWork] calibrateWithType:calibrationType];
    }
}

-(TipsView*)tipsView{
    if (!_tipsView) {
        _tipsView = [[TipsView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2-130, self.bounds.size.height / 2-80, 260, 160) okTitle:kLanguageForKey(130) cancelTitle:kLanguageForKey(131) tips:kLanguageForKey(198)];
        _tipsView.delegate=self;
        _tipsView.backgroundColor=[UIColor whiteColor];
        _tipsView.layer.cornerRadius=10;
    }
    return _tipsView;
}

#pragma mark 切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self initView];
}

- (void)frontRearViewChanged{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
}

@end
