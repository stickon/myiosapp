//
//  Network.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/3/25.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>
#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "DataModel.h"
#import "MiddleManager.h"
#import "JX_GCDTimerManager.h"
@class TCPNetwork;
#define CurrentPort 5678
#define serverPort 13133
#define TCPserverIPAddress @"www.taiheservice.com"
#define HeaderLength sizeof(SocketHeader)
static NSString *registerInfoKey = @"registerInfo";
static const DDLogLevel ddLogLevel = DDLogLevelDebug;



@interface Network : NSObject
{
    @public
    SocketHeader socketHeader;
    Byte networkType;
    
    NSString *registerUserName;//注册用
    NSString *registerPwd;
}

@property (nonatomic,assign) Byte packetNum;//包号
-(void)initSocketHeader;
-(void)initSocketHeaderNum;
-(void)disconnect;
#pragma mark tcp连接服务器
-(void)registerUserInfo;

#pragma mark deviceListView
-(void)getCurrentDeviceInfo;
-(void)updateDeviceList;
#pragma mark firstViewController
-(void)disconnnectCurrentDevice;
-(void)setDeviceRunState:(Byte)value withType:(Byte)type;
-(void)setDeviceFeedInOutState:(Byte)value withType:(Byte)type addOrDel:(Byte)isAdd  IsAll:(Byte)all;//isAdd 所有通道整体加还是减

-(void)setVibInOut:(Byte)type Value:(Byte)value;
-(void)setVibInOutSwitchStateWithType:(Byte)type;
-(void)setVibNum:(Byte)index Switch:(Byte)switchState;

#pragma mark 给料器设置
-(void)getVibSettingValue;
-(void)setVibValue:(Byte)vibtype Index:(Byte)vibIndex Value:(Byte)vibValue;
-(void)setVibState:(Byte)vibtype Index:(Byte)vibIndex State:(Byte)vibState;

#pragma mark cleanViewController

-(void)getCleanPara;
-(void)setCleanParaWithData:(Byte*)cleanData AndCloseValveType:(Byte)type;
-(void)sendCleanWithType:(Byte)cleanType;

#pragma mark valveViewController
//喷阀设置
-(void)getValvePara;
-(void)setValveParaWithData:(Byte*)valveData;

//大米版本分次喷阀设置
-(void)getGroupValvePara;
-(void)setGroupValveParaWithData:(Byte*)valveData;

#pragma mark SenseView 色选算法灵敏度 红外算法灵敏度
-(void)getAllAlgInfoWithGroup:(Byte)group Type:(Byte)visiableOrIR;
-(void)setAlgSenseValueWithGroup:(Byte)group View:(Byte)view Type:(Byte)type SubType:(Byte)subType ExtType:(Byte)extType Value:(int)value;
-(void)setAlgSenseValueWithGroup:(Byte)group View:(Byte)view Type:(Byte)type SubType:(Byte)subType ExtType:(Byte)extType Used:(Byte)used;


#pragma mark hsv hsv算法
-(void)getHsvParaWithGroup:(Byte)group View:(Byte)view;


#pragma mark svm 算法
-(void)getSvmInfoWithGroup:(Byte)group;
-(void)setSvmInfoWithGroup:(Byte)group View:(Byte)view Type:(Byte)type Value:(NSInteger)value;


-(void)getShapeWithGroup:(Byte)group;
//大米用户版本灵敏度
-(void)sendToGetRiceUserSense;
-(void)sendToSetRiceUserSenseWithType:(Byte)type GroupIndex:(Byte)group RowIndex:(Byte)index Value:(int)value;
-(void)sendToSetRiceUserSenseUseWithType:(Byte)type Value:(Byte)value;

//大米工程师灵敏度高级界面
-(void)sendToGetRiceEngineerAdvancedSenseWithType:(Byte)type;
-(void)sendToChangeRiceEnineerSenseSizeWithAlgorithmType:(Byte)algorithmType Group:(Byte)group Type:(Byte)type Value:(NSInteger)value;


#pragma mark color ir AdvancedController
-(void)sendToGetSenseAdvancedData:(Byte)type IsIR:(Byte)isIR;
-(void)sendToChangeSizeWithAlgorithmType:(Byte)algorithmType Type:(Byte)type AndValue:(NSInteger)value IsIR:(Byte)isIR;//set size
-(void)sendToChangeLightAreaSizeLimitOrBorderUseWithType:(Byte)type;

#pragma mark 灰度色差 3-1 协议 芯白 反选
-(void)getReverseSharpenWithAlgorithmType:(Byte)algorithmType;
-(void)setReverseSharpenWithAlgorithmType:(Byte)algorithmType Type:(Byte)type Chute:(Byte)chute Value:(Byte)value;
#pragma mark 红外 3-1 锐化
-(void)getIRSharpenWithAlgorithmType:(Byte)irAlgorithmType;
-(void)setIRSharpenWithAlrotithmType:(Byte)irAlgorithmType Type:(Byte)type Value:(Byte)value;
#pragma mark 波形
-(void)sendToGetWaveDataWithAlgorithmType:(Byte)type AndWaveType:(Byte)waveType AndDataType:(Byte)dataType Position:(Byte)position;
-(void)sendToGetCalibrationWave:(waveTypeCalibration*)wavetype Type:(Byte)type;
-(void)sendToGetWaveHsv:(WaveHsv*)wavetype Type:(Byte)type;
-(void)sendToGetWaveTypeAlg:(WaveTypeAlg*)wavetype Type:(Byte)type;
#pragma mark thirdViewController
#pragma mark lightsettingviewcontroller
-(void)getLight;
-(void)setLightWithType:(Byte)type AndValue:(Byte)value;
#pragma mark cameraViewController
-(void)getCameraGain;
-(void)setCameraGainWithAjustTypeAll:(Byte)ajustType Type:(Byte)type GainType:(Byte)gainType Value:(NSInteger)value;
-(void)switchCameraGainWithGainType:(Byte)gainType;
#pragma mark 系统信息
-(void)getVersionWithType:(Byte)extendtype CameraType:(Byte)cameraType;//版本信息
-(void)getSysCheckInfo;//系统自检信息
-(void)getSysWorkTimeInfo;//系统工作信息

#pragma mark 方案
-(void)getSmallModeNameListWithBigModeIndex:(Byte)bigModeIndex;
-(void)useModeWithIndex:(Byte)smallModeIndex BigModeIndex:(Byte)bigModeIndex;
-(void)getModeSettingWithIndex:(Byte)smallModeIndex BigModeIndex:(Byte)bigModeIndex;
-(void)changeModeSettingWithMode:(Byte*)mode shape:(Byte)shapeIndex svm:(Byte)useSvm hsv:(Byte)useHsv ModeLength:(Byte)modeLength;
-(void)saveCurrentMode;
#pragma mark 喷阀频率
-(void)getValveFrequency;

#pragma mark 光学校准
-(void)getCalibrationPara;
-(void)setCalibrationParaWithType:(Byte)type Data:(Byte)value;
-(void)calibrateWithType:(Byte)type;
-(void)changeWaveDataWithType:(Byte)type;

#pragma mark 相机校准
-(void)setCameraCalibrationEnable:(Byte)value;
#pragma mark 履带
-(void)switchCaterpillar:(Byte)value withLayerIndex:(Byte)index;
-(void)getCaterpillarSpeed;
-(void)setCaterpillarSpeedByte1:(Byte)highByte Byte2:(Byte)lowByte;
-(void)getCaterpillarSettingSpeed;
#pragma mark svm
-(void)getSvmPara;
-(void)setSvmParaWithType:(Byte)type AndData:(NSInteger)data;

#pragma mark hsv
-(void)getHsvPara;
-(void)setHsvParaWithHsvIndex:(Byte)index Type:(Byte)type AndData:(NSInteger)data;
-(void)changeHsvWithType:(Byte)type Index:(Byte)index;//灵敏度1、2切换 偏移切换 料槽切换

#pragma mark 腰果
-(void)getCashewSet;
-(void)setCashewSetUseStateWithType:(Byte)type;
-(void)setCashewSetParaWithType:(Byte)type Value:(NSInteger)value;//type1 1：选小 2：选大   type2 1:最小点数 2：最大点数

#pragma mark 大米
-(void)getRice;
-(void)setRiceParaWithType:(Byte)type Value:(NSInteger)value;
-(void)setRiceUseStateWithType:(Byte)type;

#pragma mark 花生芽头
-(void)getPeanutbud;
-(void)setPeanutbudEditWithIndex:(Byte)index Data:(int)data;
-(void)setPeanutbudBtnWithIndex:(int)index Data:(int)data;
#pragma mark 标准形选或通用茶叶
-(void)getStandard;
-(void)setStandardValueWithType:(Byte)type Value:(NSInteger)value;
-(void)setStandardStateWithType:(Byte)type State:(Byte)state;

#pragma mark 茶叶
-(void)getTea;
-(void)setTeaValueWithType:(Byte)type Value:(NSInteger)value;
-(void)setTeaStateWithType:(Byte)type State:(Byte)state;

#pragma mark 甘草 0x17
-(void)getLicorice;
-(void)setLicoriceValueWithType:(Byte)type Value:(Byte)value;
-(void)setLicoriceStateWithType:(Byte)type State:(Byte)state;

#pragma mark 小麦 0x18
-(void)getWheat;
-(void)setWheatValueWithType:(Byte)type Value:(NSInteger)value;
-(void)setWheatState:(Byte)state;

#pragma mark 稻种0x19
-(void)getSeed;
-(void)setSeedValueWithType:(Byte)type Value:(Byte)value;
-(void)setSeedState:(Byte)state;

#pragma mark 葵花籽0x1a
-(void)getSunflower;
-(void)setSunflowerWithType:(Byte)type Value:(NSInteger)value;
-(void)setSunflowerState:(Byte)state;

#pragma mark 玉米 0x1b
-(void)getCorn;
-(void)setCornWithType:(Byte)type Value:(Byte)value;
-(void)setCornStateWithType:(Byte)type State:(Byte)state;

#pragma mark 蚕豆 0x1c
-(void)getHorseBean;
-(void)setHorseBeanWithType:(Byte)type Value:(Byte)value;
-(void)setHorseBeanStateWithType:(Byte)type State:(Byte)state;

#pragma mark 绿茶 0x1d
-(void)getGreenTea;
-(void)setGreenTeaWithType:(Byte)type Value:(NSInteger)value;
-(void)setGreenTeaStateWithType:(Byte)type State:(Byte)state;

#pragma mark 红茶 0x1e
-(void)getRedTea;
-(void)setRedTeaWithType:(Byte)type Value:(NSInteger)value;
-(void)setRedTeaStateWithType:(Byte)type State:(Byte)state;

#pragma mark 绿茶短梗 0x1f
-(void)getGreenTeaSG;
-(void)setGreenTeaSGWithType:(Byte)type Value:(NSInteger)value;
-(void)setGreenTeaSGStateWithType:(Byte)type State:(Byte)state;

#pragma mark 选长米 0x20
-(void)getLengthRice;
-(void)setLengthRiceSenseWithGroup:(Byte)group Value:(Byte)value;
-(void)setLengthRiceUseState:(Byte)state;

#pragma mark 选碎米 0x21
-(void)getBrokenRice;
-(void)setBrokenRiceSenseWithIndex:(Byte)index Value:(NSInteger)value;
-(void)setBrokenRiceUseState:(Byte)state;
#pragma mark 切换层和视
-(void)changeLayerAndView;


#pragma mark 页面 进入和退出
-(void)changeViewPagesWithPageId:(Byte)pageId State:(Byte)state;

-(void)netWorkSendData;
-(void)netWorkSendDataWithData:(NSData*)data;
-(BOOL)open;
-(void)close;
-(void)closeTimer;
-(void)connectwithString1:(NSString*)string1 String2:(NSString*)string2;
-(void)didnotsend;
-(void)receiveSocketData:(NSData *)data fromAddressIP:(NSString *)IPaddress;

@end
