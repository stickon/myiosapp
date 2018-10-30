//
//  Device.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/3/15.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "types.h"
#import "common_struct.h"
@interface Device : NSObject
{
    @public
    Byte screenProtocolMainVersion;//当前连接的屏的协议的主版本号
    Byte screenProtocolMinVersion;//次版本号
    Byte screenProtocolType;//协议类型，大米机型为1 其它机型为0
    MachineData machineData;
    ColorAlgorithm *colorAlgorithm;
    ColorAlgorithm *irAlgorithm;
    RiceUserAlgorithm *riceUserAlgorithm;
    Sense sense;
    RiceSense riceSense;
    Byte colorOrDiffAlgorithmUseState;//当前算法高级界面使能状态
    Byte reverse;//镜像   0 无  1 有
    Byte sharpen;//锐化 0 无  1 有
    Byte irSharpenEnable;//红外锐化使用禁用
    Byte irSharpenValue;//红外锐化值
    Byte IsirDiffOrSpot;//设置杂质大小中是否为红外比例 比例为0 点数为1
    Byte irDiffOrSpot[2];//设置杂质大小中存放红外比例或点数
    Byte lightAreaLimit;//亮度区域高级设置杂质大小中 上限 下限
    Byte lightAreaBorderUse;//亮度区域高级设置杂质大小中 边缘使能
    Byte *data1;//x:实际数量  如果是RGB，一次的值；
    Byte *data2;//x:实际数量 如果是RGB，二次的值；如果是色差，亮度下限的值
    Byte *data3;//x:实际数量 如果是色差，亮度下限的值
    Byte *data4;//x:反选的值
    Byte waveData[5][WaveLength];//r g b ir1 ir2
    Byte waveDataCount;
    Byte calibrationWaveData[5][CalibrationWaveLength];//光学校准数据
    Byte hsvPointX[1024];//hsv 噪声点x坐标
    Byte hsvPointY[1024];//hsv 噪声点y坐标
    Byte hsvLight[256];//hsv亮度线
    RequestWaveType requestWaveType;
    WaveType waveType;
    CleanPara cleanPara;
    ValvePara valvePara;
    
    /*****阀设置*****/
    //主版本
    Byte *delayTime;
    Byte *blowTime;
    Byte *ejectorType;
    Byte *bUseCenterPoint;
    //大米机分次版本
    Byte *groupDelayTime;
    Byte *groupBlowTime;
    Byte *groupEjectorType;
    Byte *groupUseCenterPoint;
    Byte *groupOpenValveTime;
    Byte *groupValveWorkMode;
    
    
    /***软件版本**/
    BaseVersion baseVersion;
    ColorBoardVersion *colorBoardVersion;
    CameraVersion *normalCameraVersion;
    CameraVersion *infraredCameraVersion;
    CameraVersion *infraredCameraVersion2;//双红外
    LightSetting lightSetting;
    CameraGain cameraGain;
    
    
    Byte shape;              	//型选索引,0 不使用。
//    Byte useSvm;                    //智能分选 0不使用 1使用
//    Byte useHsv;                //色度分选 0不使用 1使用
    Byte valveCount;
    Byte valveFrontRear;
    Byte *frontValveFrequency;
    Byte *rearValveFrequency;
    Byte *valveFrequency;
    Caterpillar caterpillar; //当前层履带
    Byte waveAvgData;
    Byte waveDiffData;
    
    WorkTime workTime;//系统工作时间
    
    Svm svm;
    Byte showSvmSecond;//是否显示svm二次
    Byte svmIsProportion;//比例还是点数 比例1 点数0
    
    HsvSense hsv[2];//灵敏度1 灵敏度2
    BOOL hasHsv2;//是否有hsv2
    Byte currentHsvIndex;//当前hsv索引
    Byte currentHsvLightColorIndex;//当前hsv亮度线颜色索引
    Byte hsvOffset;//是否偏移
    CashewSet cashew;//腰果
    RiceShape riceShape;//大米
    PeanutbudSet peanutbud;//花生芽头
    Peanutbud3Set peanutbud3;//花生芽头3
    StandardShapeSet standardShape;//标准形选和通用茶叶
    TeaShapeSet tea;//茶叶
    Licorice licorice;//甘草
    WheatShapeSet wheat;// 小麦
    SeedShapeSet seed;//稻种
    SunflowerShapeSet sunflower;
    CornShapeSet corn;
    HorseBeanShapeSet horseBean;//蚕豆
    GreenTeaShapeSet greenTea;//绿茶
    RedTeaShapeSet redTea;
    GreenTeaSGShapeSet greenTeaSG;//绿茶短梗
    LengthRice lengthRice;//选长米
    BrokenRice brokenRice;//选碎米
    VibSet vibSet;
    Byte *vibdata;//每个通道的给料量
    Byte *vibSwitch;//每个通道的给料量开关
    
    
    Byte groupNum;//大米分次
    int groupLastSort[4];
    Byte SortBelongToGroup[10];
    
    
    RiceGroupSense riceGroupSense;
    Byte *groupSenseLength;
    Byte *groupSenseWidth;
    Byte (*groupSenseSize)[2];
    Byte (*groupSharpenCKValue)[2];
    Byte (*groupmirrorCKValue)[2];
}
@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *deviceID;
@property (nonatomic,strong) NSString *deviceIP;
@property (nonatomic,assign) Byte errorState;//失败类型 1: 配置文件错误 2: 控制板通信异常，不能启动3: 气压异常，不能启动
@property (nonatomic,strong) NSString *modeName;//用于首页显示的当前方案名称
@property (nonatomic,assign) NSInteger colorAlgorithmNums;
@property (nonatomic,assign) NSInteger irAlogrithmNum;

@property (nonatomic,assign) NSInteger userAlgorithmNums;//用户版本显示的算法数量
@property (nonatomic,assign) Byte currentLayerIndex;
@property (nonatomic,assign) Byte currentSorterIndex;
@property (nonatomic,assign) Byte currentViewIndex;
@property (nonatomic,assign) Byte currentGroupIndex;
@property (nonatomic,assign) Byte svmGroupNum;
@property (nonatomic,strong) NSString *displayScreenVersion;
@property (nonatomic,strong) NSMutableArray *modeList1;//大方案1中小方案列表数组
@property (nonatomic,strong) NSMutableArray *modeList2;//大方案2中小方案列表数组
@property (nonatomic,strong) NSMutableArray *modeList3;//大方案3中小方案列表数组
@property (nonatomic,strong) NSMutableArray *modeList4;//大方案4中小方案列表数组
@property (nonatomic,strong) NSMutableArray *modeList5;//大方案5中小方案列表数组

@property (nonatomic,strong) NSMutableArray *bigModeList;//大方案列表数组

@property (nonatomic,assign) Byte currentSelectBigModeIndex;//当前选择查看的大模式索引
@property (nonatomic,assign) Byte addDigitGain;//是否显示数字增益
@property (nonatomic,assign) Byte currentCameraGain;// 0模拟 1数字
@property (nonatomic,strong) NSString *sysCheckInfo;//系统自检信息

-(instancetype)initWithName:(NSString*)deviceName ID:(NSString*)deviceID IP:(NSString*)deviceIP;
-(BOOL)bHaveChuteUseReverse;// 是否有料槽使用反选功能
@end
