//
//  HsvView.m
//  thColorSort
//
//  Created by huanghu on 2018/1/17.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "HsvView.h"
#import "HsvColorPaletteView.h"
#import "JX_GCDTimerManager.h"
@interface HsvView ()<MyTextFieldDelegate,HsvColorPaletteChangeHsvDelegate,UIGestureRecognizerDelegate>{
    NSTimer *longPressTimer;//长按定时器
}
@property (strong, nonatomic) IBOutlet HsvColorPaletteView *colorPaletteView;
@property (strong, nonatomic) IBOutlet UIButton *frontViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearViewBtn;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstraintHeight;
@property (strong, nonatomic) IBOutlet UIButton *offsetBtn;//图像偏移按钮
@property (strong, nonatomic) IBOutlet UILabel *offsetTitleLabel;//图像偏移文字
@property (strong, nonatomic) IBOutlet UILabel *chuteTitleLabel;//料槽文字
@property (strong, nonatomic) IBOutlet BaseUITextField *chuteNumTextField;//料槽输入框
@property (strong, nonatomic) IBOutlet UIButton *usedStateBtn;//使能按钮
@property (strong, nonatomic) IBOutlet UIButton *topBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;
@property (strong, nonatomic) IBOutlet UIView *directView;
@end

static NSString *HsvWaveTimer = @"HsvWaveTimer";
static NSString *longPressTimer = @"LongPressTimer";
@implementation HsvView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"HsvView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self.colorPaletteView setIsoffset:1];
    self.colorPaletteView.delegate = self;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self initView];
    [[NetworkFactory sharedNetWork] getHsvPara];
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    self.chuteNumTextField.text = [NSString stringWithFormat:@"%d",device.currentSorterIndex];
    
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:HsvWaveTimer
                                                           timeInterval:2.0
                                                                  queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf hsvWaveTimerOut];
                                                                 }];
    
    UILongPressGestureRecognizer *toplongPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGR:)];
    toplongPressGR.minimumPressDuration = 0.5;
    [self.topBtn addGestureRecognizer:toplongPressGR];
    
    UILongPressGestureRecognizer *rightlongPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGR:)];
    [self.rightBtn addGestureRecognizer:rightlongPressGR];
    
    UILongPressGestureRecognizer *bottomlongPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGR:)];
    [self.bottomBtn addGestureRecognizer:bottomlongPressGR];
    
    UILongPressGestureRecognizer *leftlongPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGR:)];
    [self.leftBtn addGestureRecognizer:leftlongPressGR];
    return self;
}

-(void)refreshCurrentView{
    Device *device = kDataModel.currentDevice;
    [gNetwork getHsvParaWithGroup:device.currentGroupIndex View:device.currentViewIndex];
}

#pragma mark longPressGR
int temphsvHstart;
int temphsvHend;
int temphsvSstart;
int temphsvSend;
- (void)LongPressGR:(UILongPressGestureRecognizer *)gesture{
    int index = self.colorPaletteView->currentHsvIndex;
    UIButton *btn=(UIButton *)gesture.view;
    DDLogInfo(@"%d",btn.highlighted);
    if(gesture.state==UIGestureRecognizerStateBegan){
        DDLogInfo(@"%d",btn.highlighted);
        btn.highlighted = YES;
        temphsvHstart = self.colorPaletteView->hsvHstart[index];
        temphsvHend = self.colorPaletteView->hsvHend[index];
        temphsvSstart = self.colorPaletteView->HsvSstart[index];
        temphsvSend = self.colorPaletteView->hsvSend[index];
        
        longPressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            btn.highlighted = YES;
            if (btn.tag == 0) {
                temphsvHstart--;
                temphsvHend--;
                
                if (temphsvHstart < 0) {
                    temphsvHstart+=360;
                }
                if (temphsvHend < 0) {
                    temphsvHend+=360;
                }
                self.colorPaletteView->hsvHstart[index] = temphsvHstart;
                self.colorPaletteView->hsvHend[index] = temphsvHend;
                
            }else if (btn.tag == 1){
                temphsvSstart++;
                temphsvSend++;
                
                if (temphsvSstart>255) {
                    temphsvSstart = 255;
                }
                if (temphsvSend >255) {
                    temphsvSend = 255;
                }
                
                self.colorPaletteView->HsvSstart[index] = temphsvSstart;
                self.colorPaletteView->hsvSend[index] = temphsvSend;
                
            }else if (btn.tag == 2){
                temphsvHstart++;
                temphsvHend++;
                if (temphsvHstart > 360) {
                    temphsvHstart-=360;
                }
                if (temphsvHend > 360) {
                    temphsvHend-=360;
                }
                self.colorPaletteView->hsvHstart[index] = temphsvHstart;
                self.colorPaletteView->hsvHend[index] = temphsvHend;
                
            }else if (btn.tag == 3){
                temphsvSstart--;
                temphsvSend--;
                
                if (temphsvSstart < 0) {
                    temphsvSstart = 0;
                }
                if (temphsvSend < 0) {
                    temphsvSend = 0;
                }
                self.colorPaletteView->HsvSstart[index] = temphsvSstart;
                self.colorPaletteView->hsvSend[index] = temphsvSend;
            }
            [self.colorPaletteView setNeedsDisplay];
        }];
    }else{
        DDLogInfo(@"%d",btn.highlighted);
        if (gesture.state == UIGestureRecognizerStateChanged) {
            return;
        }
        btn.highlighted = NO;
        if(longPressTimer!=nil){
            [longPressTimer invalidate];
            longPressTimer=nil;
            if (btn.tag == 0 ||btn.tag == 2) {
                [[NetworkFactory sharedNetWork] setHsvParaWithType:8 AndData:temphsvHstart];
                [[NetworkFactory sharedNetWork] setHsvParaWithType:9 AndData:temphsvHend];
            }else if (btn.tag == 1 || btn.tag == 3){
                [[NetworkFactory sharedNetWork] setHsvParaWithType:6 AndData:temphsvSstart];
                [[NetworkFactory sharedNetWork] setHsvParaWithType:7 AndData:temphsvSend];
            }
        }
        
    }
}

- (void)hsvWaveTimerOut{
    [[NetworkFactory sharedNetWork] sendToGetWaveDataWithAlgorithmType:0 AndWaveType:wave_hsv AndDataType:0 Position:0];
}
- (void)initView{
    [self initLanguage];
    self.usedStateBtn.layer.cornerRadius = 3.0f;
    self.offsetBtn.layer.cornerRadius=5;
    self.offsetBtn.layer.masksToBounds=YES;
    Device *device = kDataModel.currentDevice;
    self.usedStateBtn.tintColor = [UIColor clearColor];
    self->viewBtn[0] = self.frontViewBtn;
    self->viewBtn[1] = self.rearViewBtn;
    self.leftBtn.tag = 0;
    self.topBtn.tag = 1;
    self.rightBtn.tag = 2;
    self.bottomBtn.tag = 3;
    [super frontRearViewBtnAddTargetEvent];
    if (device.currentViewIndex == 0) {
        self.frontViewBtn.selected = true;
        self.frontViewBtn.backgroundColor = [UIColor greenColor];
        self.frontViewBtn.userInteractionEnabled = NO;
        self.rearViewBtn.userInteractionEnabled = YES;
        self.rearViewBtn.selected = false;
        self.rearViewBtn.backgroundColor = [UIColor TaiheColor];
    }else if (device.currentViewIndex == 1){
        self.frontViewBtn.selected = false;
        self.frontViewBtn.backgroundColor = [UIColor TaiheColor];
        self.rearViewBtn.selected = true;
        self.rearViewBtn.backgroundColor = [UIColor greenColor];
        self.frontViewBtn.userInteractionEnabled = YES;
        self.rearViewBtn.userInteractionEnabled = NO;
    }
}
- (void)initLanguage{
    [self.frontViewBtn setTitle:kLanguageForKey(75) forState:UIControlStateNormal];
    [self.rearViewBtn setTitle:kLanguageForKey(76) forState:UIControlStateNormal];
    self.title =  kLanguageForKey(338);
    self.offsetTitleLabel.text = kLanguageForKey(339);
    self.chuteTitleLabel.text = kLanguageForKey(41);
    
    [self.usedStateBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.usedStateBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char *a = headerData.bytes;
    if (a[0] == 0x09) {
        if(a[1]== 1){
            [self updateView];
        }else if (a[1] == 2){
            [self updateCurrentHsvView];
        }else if (a[1] == 3){
            if (a[2] == 3) {
                [[NetworkFactory sharedNetWork] getHsvPara];
            }else{
                [self updateView];
            }
        }
    }else if (a[0] == 0x5){
        if (a[1] == wave_hsv) {
            [self updateHsvWaveData];
        }
    }else if(a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getHsvPara];
    }
}

- (void)updateHsvWaveData{
    Device *device = kDataModel.currentDevice;
    if (device) {
        memcpy(self.colorPaletteView->pointX, device->hsvPointX, 1024);
        memcpy(self.colorPaletteView->pointY, device->hsvPointY, 1024);
        memcpy(self.colorPaletteView->lightY, device->hsvLight, 256);
        [self.colorPaletteView setNeedsDisplay];
    }
    
}
- (void)updateCurrentHsvView{
    Device *device = kDataModel.currentDevice;
    Byte hsvIndex = device->currentHsvIndex;
//    self.widthTextField.text = [NSString stringWithFormat:@"%d",device->hsv[hsvIndex].width];
//    self.heightTextField.text = [NSString stringWithFormat:@"%d",device->hsv[hsvIndex].height];
//    self.sizeTextField.text = [NSString stringWithFormat:@"%d",device->hsv[hsvIndex].number[0]*256+device->hsv[hsvIndex].number[1]];
//    if (device->hsv[hsvIndex].hsvUse == 1) {
//        self.usedStateBtn.selected = YES;
//        self.usedStateBtn.backgroundColor = [UIColor greenColor];
//    }else{
//        self.usedStateBtn.selected = NO;
//        self.usedStateBtn.backgroundColor = [UIColor TaiheColor];
//    }
    
    self.colorPaletteView->HsvSstart[hsvIndex] = device->hsv[hsvIndex].s[0];
    self.colorPaletteView->hsvSend[hsvIndex] = device->hsv[hsvIndex].s[1];
    self.colorPaletteView->hsvVstart[hsvIndex] = device->hsv[hsvIndex].v[0];
    self.colorPaletteView->hsvVend[hsvIndex] = device->hsv[hsvIndex].v[1];
//    self.colorPaletteView->hsvUsed[hsvIndex] = device->hsv[hsvIndex].hsvUse;
    [self.colorPaletteView setNeedsDisplay];
}
- (void)updateView{
    Device *device = kDataModel.currentDevice;
    int hsvHstart = device->hsv[0].h[0][0]*256+device->hsv[0].h[0][1];
    int hsvHEnd = device->hsv[0].h[1][0]*256+device->hsv[0].h[1][1];
    self.colorPaletteView->hsvHstart[0] = hsvHstart;
    self.colorPaletteView->hsvHend[0] = hsvHEnd;
    self.colorPaletteView->HsvSstart[0] = device->hsv[0].s[0];
    self.colorPaletteView->hsvSend[0] = device->hsv[0].s[1];
    self.colorPaletteView->hsvVstart[0] = device->hsv[0].v[0];
    self.colorPaletteView->hsvVend[0] = device->hsv[0].v[1];
    self.colorPaletteView->hashsv2 = device->hasHsv2;
//    self.colorPaletteView->hsvUsed[0] = device->hsv[0].hsvUse;
    self.colorPaletteView->currentHsvIndex = device->currentHsvIndex;
    self.colorPaletteView->lightColorIndex = device->currentHsvLightColorIndex;
    self.colorPaletteView.offset = device->hsvOffset;
    if (device->hsvOffset) {
        self.offsetBtn.selected = YES;
    }else{
        self.offsetBtn.selected = NO;
    }
    if (device->hasHsv2) {
        int hsv2Hstart = device->hsv[1].h[0][0]*256+device->hsv[1].h[0][1];
        int hsv2HEnd = device->hsv[1].h[1][0]*256+device->hsv[1].h[1][1];
        self.colorPaletteView->hsvHstart[1] = hsv2Hstart;
        self.colorPaletteView->hsvHend[1] = hsv2HEnd;
        self.colorPaletteView->HsvSstart[1] = device->hsv[1].s[0];
        self.colorPaletteView->hsvSend[1] = device->hsv[1].s[1];
        self.colorPaletteView->hsvVstart[1] = device->hsv[1].v[0];
        self.colorPaletteView->hsvVend[1] = device->hsv[1].v[1];
//        self.colorPaletteView->hsvUsed[1] = device->hsv[1].hsvUse;
    }
    [self updateCurrentHsvView];
    [self.colorPaletteView setNeedsDisplay];
}

- (IBAction)hsvIndexChanged:(UIButton *)sender {
    
}

- (IBAction)useStateChanged:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setHsvParaWithType:13 AndData:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setHsvParaWithType:13 AndData:0];
    }
}

- (IBAction)offsetBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.colorPaletteView setIsoffset:0];
        [[NetworkFactory sharedNetWork]changeHsvWithType:2 Index:1];
    }else{
        [self.colorPaletteView setIsoffset:1];
        [[NetworkFactory sharedNetWork] changeHsvWithType:2 Index:0];
    }
    
}
- (IBAction)directionBtnClicked:(UIButton *)sender {
    int index = self.colorPaletteView->currentHsvIndex;
    if (sender.tag == 0) {
        int temphsvHstart = --self.colorPaletteView->hsvHstart[index];
        int temphsvHend = --self.colorPaletteView->hsvHend[index];
        
        if (temphsvHstart < 0) {
            temphsvHstart+=360;
        }
        if (temphsvHend < 0) {
            temphsvHend+=360;
        }
        [[NetworkFactory sharedNetWork] setHsvParaWithType:8 AndData:temphsvHstart];
        [[NetworkFactory sharedNetWork] setHsvParaWithType:9 AndData:temphsvHend];
    }else if (sender.tag == 1){
        int temphsvSstart = ++self.colorPaletteView->HsvSstart[index];
        int temphsvSend = ++self.colorPaletteView->hsvSend[index];
        
        if (temphsvSstart>255) {
            temphsvSstart = 255;
        }
        if (temphsvSend >255) {
            temphsvSend = 255;
        }
        [[NetworkFactory sharedNetWork] setHsvParaWithType:6 AndData:temphsvSstart];
        [[NetworkFactory sharedNetWork] setHsvParaWithType:7 AndData:temphsvSend];
        
    }else if (sender.tag == 2){
        int temphsvHstart = ++self.colorPaletteView->hsvHstart[index];
        int temphsvHend = ++self.colorPaletteView->hsvHend[index];
        if (temphsvHstart > 360) {
            temphsvHstart-=360;
        }
        if (temphsvHend > 360) {
            temphsvHend-=360;
        }
        [[NetworkFactory sharedNetWork] setHsvParaWithType:8 AndData:temphsvHstart];
        [[NetworkFactory sharedNetWork] setHsvParaWithType:9 AndData:temphsvHend];
        
    }else if (sender.tag == 3){
        int temphsvSstart = --self.colorPaletteView->HsvSstart[index];
        int temphsvSend = --self.colorPaletteView->hsvSend[index];
        if (temphsvSstart < 0) {
            temphsvSstart = 0;
        }
        if (temphsvSend < 0) {
            temphsvSend = 0;
        }
        [[NetworkFactory sharedNetWork] setHsvParaWithType:6 AndData:temphsvSstart];
        [[NetworkFactory sharedNetWork] setHsvParaWithType:7 AndData:temphsvSend];
        
    }
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 4) {
    }else if (sender.tag == 100){
        Device *device = kDataModel.currentDevice;
        [sender initKeyboardWithMax:device->machineData.chuteNumber Min:1 Value:sender.text.integerValue];
    }
}

#pragma mark colorpalette delegate

- (void)hsvColorPaletteSetIndex:(int)index{
    [[NetworkFactory sharedNetWork] changeHsvWithType:1 Index:index];
}

#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    if (sender.tag == 100) {
        Device *device = kDataModel.currentDevice;
        device.currentSorterIndex = sender.text.integerValue;
        [[NetworkFactory sharedNetWork] changeHsvWithType:3 Index:device.currentSorterIndex-1];
    }else{
        [[NetworkFactory sharedNetWork] setHsvParaWithType:sender.tag AndData:sender.text.integerValue];
    }
}
#pragma mark -baseviewcontroller

- (void)networkError:error{
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:HsvWaveTimer];
    [super networkError:error];
}
-(void)socketSendError{
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:HsvWaveTimer];
    [super socketSendError];
}

-(BOOL)Back{
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:HsvWaveTimer];
    return [super Back];
}
#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getHsvPara];
}
-(void)frontRearViewChanged{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [[NetworkFactory sharedNetWork] getHsvPara];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentViewConstraintHeight.constant = self.colorPaletteView.frame.size.height+550;
}


@end
