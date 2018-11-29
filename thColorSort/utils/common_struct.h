//
//  common_struct.h
//  thColorSort
//
//  Created by huanghu on 2018/7/5.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#ifndef common_struct_h
#define common_struct_h


typedef struct
{
    ///状态
    Byte valveState;      //阀状态
    Byte feederState;     //给料器
    Byte startState;         //启动状态
    Byte cleanState;      //清灰状态
    Byte machineType;        //机器类型
    Byte layerNumber;        //层数
    Byte chuteNumber;        //通道数
    Byte groupNum;           //分组数
    Byte useShape;           //是否使用形选
    Byte useIR;              //是否使用红外
    Byte useSvm;             //是否使用SVM
    Byte useColor;           //色选算法的个数，0：未使用
    Byte useHsv;             //是否使用hsv算法
    Byte useSensor;          //使用料位传器
    
    Byte useLevel; ///用户权限  0 user 1:工程师 2:厂家
    Byte pixelType;//像素类型，在画相机校准线时用到
    //方案参数
    Byte sortModeBig;     //大模式
    Byte sortModeSmall;   //小模式
    char  modeName[100];    //当前方案名称
    Byte reserver[100];      //保留
}MachineData;

typedef struct MachineCfgParam{
    BOOL bHasIR;
    BOOL bHasSharpen;
    BOOL bHasMirror;
    BOOL bHasVideo;
    BOOL bHasIntelligent;
    BOOL bHasSVM;
    BOOL bHasAIClean;
    BOOL bHasPhone;
}MachineCfgParam;

typedef struct ColorAlgorithm
{
    Byte type;            //算法类型 [1-6]
    Byte view;            //前视、后视[0/1]
    Byte sense[2];           //灵敏度值  sense[0]:高位  sense[1]:低位
    Byte used;            //使能是否打开
    char name[100];       //算法名称
}ColorAlgorithm;

typedef struct RiceUserAlgorithm{
    Byte type;
    Byte view;
    Byte sense[4][2];
    Byte range[4];
    Byte used;
    char name[100];
}RiceUserAlgorithm;
typedef struct
{
    Byte type;    //   0-色选,    1-红外,
    Byte subType; //算法 0~n
    Byte extType;
    Byte view;   //前视/后视  0/1
    Byte sense[2];  // 灵敏度值 【高位，低位】[0]是高位
    
    Byte senseMin[2];
    Byte senseMax[2];
    Byte used;   //算法使能状态
    Byte res;
    char    name[100];  //算法名称
}ColorAlg;

typedef struct sense
{
    Byte layer;           //层
    Byte view;            //视
    Byte algorithm;       //算法
    Byte width;           //长
    Byte height;          //宽
    Byte size[2];            //点数
    Byte fSameR;          //前后视相同
    Byte color;           //色差颜色
}Sense;
typedef struct RiceSense{//针对选大米用
    Byte repair; //修复值
    Byte sharpenUse; //是否增强
    Byte sharpenValue; //锐化值
}RiceSense;

typedef struct{//大米分次高级
    Byte layer;
    Byte view;
    Byte algorithm;
    Byte color;
    Byte fSameR;
}RiceGroupSense;

typedef struct{
    Byte algorithm;
    Byte layer;
    Byte view;
    Byte ch;
    Byte type;
}RequestWaveType;
typedef struct waveType
{
    Byte waveDataColorType;
    Byte terminal;//一次终止 灰度分割点
    Byte firstUpperLimit;
    Byte firstLowerLimit;
    Byte SecondUpperLimit;
    Byte SecondLowerLimit;
}WaveType;

typedef struct CleanPara
{
    Byte cleanCycle;
    Byte cleanDelay;
    Byte cleanTime;
    Byte cleanSwitch;
}CleanPara;

typedef struct ValvePara
{
    Byte openValveTime;
    Byte valveWorkMode;
}ValvePara;

typedef struct Valve2TimesPara{
    Byte openValveTime;
    Byte ValveWorkMode;
    Byte DelayTime[2];
    Byte BlowTime[2];
    Byte EjectorType[2];
    Byte bUseCenterPoint[2];
}Valve2TimesPara;

typedef struct IRValve{
    Byte DelayTime[2];
    Byte BlowTime[2];
}IRValve;

typedef struct BaseVersion
{
    Byte control[2];
    Byte convert[2];
    Byte led[2];
    Byte sensor[2];
    Byte wheel[2];
    Byte loaded;
}BaseVersion;

typedef struct ColorBoardVersion
{
    Byte ch;
    Byte arm[2];
    Byte fpga[2];
    Byte hardware[2];
}ColorBoardVersion;

typedef struct CameraVersion
{
    Byte ch;
    Byte front_software[2];
    Byte front_hardware[2];
    Byte rear_software[2];
    Byte rear_hardware[2];
}CameraVersion;

typedef struct
{
    Byte r[2];               //r
    Byte g[2];             //g
    Byte b[2];             //b
    Byte MainLight[2];     //前后主灯
    Byte ir[2];              //前后红外开关
}LightSetting;

typedef struct{
    Byte r[4];         //r  r[0] :front high r[1]: front low ; r[2] :rear high r[3]: rear low
    Byte g[4];             //g
    Byte b[4];             //b
    Byte ir1[2];           //红外1
    Byte ir2[2];          //红外2
}CameraGain;



typedef struct{//履带
    Byte state;//开关
    Byte speed[2];//转速
    Byte settingSpeedMin[2];//最小设置速度
    Byte settingSpeedMax[2];//最大设置速度
}Caterpillar;
typedef struct
{
    Byte used;
    Byte blowSample;
    Byte spotDiff_1[2];  //1次杂质比
    Byte sensor_1;   //1次灵敏度
    Byte spotDiff_2[2];  //2次杂质比
    Byte sensor_2;   //2次灵敏度
}Svm;
typedef struct
{
    Byte view;
    Byte used;
    Byte blowSample;
    Byte spotDiff[2];                      //杂质比        spotDiff[0]是高位
    Byte spotDiffMax[2];              //杂质比上限  spotDiffMax[0]是高位
    Byte spotSensor;                     //灵敏度
}SvmInfo;

typedef struct//腰果形选
{
    Byte useType;             //选中状态 0：禁用 1：选小 2：选大
    Byte textView[3][2];     //选大灵敏度小，选小灵敏度 灰尘限制
}CashewSet;

typedef struct//大米形选
{
    Byte buttonUse[2];        //4 button 从左到右，从上到下
    Byte textView[3][2];    //3 edit 从左到右，从上到下,双字节};
}RiceShape;

typedef struct//标准形选和通用茶叶
{
    Byte buttonUse[5];
    Byte textView[10][2];
    
}StandardShapeSet;

typedef struct//花生芽头
{
    Byte buttonUse[3];            //1次二次灵敏度
    Byte textView[2];   //1次二次,皮抑制开关
    Byte isHasSecond;          //是否有二次
}PeanutbudSet;

typedef struct{//协议 3 花生芽头
    Byte buttonUse[3];  //同上
    Byte textView[12];
    Byte isHasSecond;
} Peanutbud3Set;
typedef struct//茶叶 铁观音和大红袍
{
    Byte buttonUse[4];        //4 button 从左到右，从上到下
    Byte textView[5][2];    //5 edit 从左到右，从上到下,双字节
}TeaShapeSet;
typedef struct//甘草
{
    Byte buttonUse[4];        //4 button 从左到右，从上到下
    Byte textView[7];      //7 edit 从左到右，从上到下,双字节
}Licorice;

typedef struct // 小麦
{
    Byte buttonUse;        //1 button 从左到右，从上到下
    Byte textView[4][2];    //4 edit 从左到右，从上到下,双字节};
    Byte isHasSecond;          //是否有二次
}WheatShapeSet;

typedef struct //稻种
{
    Byte buttonUse;        //1 button 从左到右，从上到下
    Byte textView[8];    //8 edit 从左到右，从上到下,单字节};
    Byte isHasSecond;          //是否有二次
}SeedShapeSet;


typedef struct
{
    Byte buttonUse;        //1 button 从左到右，从上到下
    Byte textView[4][2];    //4 edit 从左到右，从上到下,双字节};
    Byte isHasSecond;          //是否有二次
}SunflowerShapeSet;

typedef struct
{
    Byte buttonUse[2];        //2 button 从左到右，从上到下
    Byte textView[8];       //8 edit 从左到右，从上到下,单字节};
}CornShapeSet;

typedef struct
{
    Byte buttonUse[2];        //2 button 从左到右，从上到下
    Byte textView[4];      //4 edit 从左到右，从上到下,单字节};
}HorseBeanShapeSet;

typedef struct
{
    Byte buttonUse[3];        //3 button 从左到右，从上到下
    Byte textView[3];      //4 edit 从左到右，从上到下,单字节};
    Byte lastView[2];       //最后一个文本框，双字节
}GreenTeaShapeSet;
typedef struct
{
    Byte buttonUse[4];        //4 button 从左到右，从上到下
    Byte textView[9];      //8 edit 从左到右，从上到下,单字节（杂质大小双字节），
}RedTeaShapeSet;


typedef struct
{
    Byte buttonUse[4];        //4 button 从左到右，从上到下
    Byte textView[4];      //4 edit 从左到右，从上到下,单字节
    Byte lastView [2];      //最后一个EDIT 双字节
}GreenTeaSGShapeSet;

typedef struct{
    Byte buttonUse;
    Byte textView[4];
}LengthRice;

typedef struct{
    Byte buttonUse;
    Byte textView[4];
    Byte text2View[4][2];
}BrokenRice;

typedef struct
{
    Byte totalTime[4];   //总工作时间                   高位在前（和原来一样）  （分钟）
    Byte todayTime[4];   //本次工作时间 （分钟）
    Byte resever[8];     //预留
}WorkTime;


typedef struct{
    Byte ch;
    Byte inOutData[2];//入料 和 出料器的给料量
}VibSet;

typedef struct{
    Byte  v[2];           //v上限下限,2个字节
    Byte  s[2];           //s上限下限
    Byte  h[2][2];        //h上限下限
    Byte index;
}HsvSense;



typedef struct
{
    Byte type;
    Byte extendType;
    Byte data1[8];
    Byte number;
    Byte len[2];
    Byte crc[2];
}SocketHeader;
//灵敏度
typedef struct SenseValue
{
    Byte Algorithm;   //色选算法
    Byte adjustType;  //0:单通道，1：所有通
    Byte layer;
    Byte view;
    Byte ch;
    Byte frtSnd;
    Byte type; //1:灵敏度，2：色差上限 3：色差下限
    Byte data;
}SenseValue;
//色选使能 只需要利用前三个字节数据 不分料槽 使能自动取反
typedef struct SenseUse
{
    Byte Algorithm;//色选算法
    Byte layer;
    Byte view;
    Byte ch;
    Byte data;
}SenseUse;

typedef struct RiceUserSense{
    Byte type;
    Byte layer;
    Byte view;
    Byte group;
    Byte index;
    Byte data[2];
}RiceUserSense;

typedef struct SenseSize
{
    Byte Algorithm;   //色选算法
    Byte layer;
    Byte view;
    Byte fSameR;//前后视相同
    Byte type; //长宽点(1/2/3)
    Byte data[2];
}SenseSize;

typedef struct SenseGroupSetSize{
    Byte algorithm;
    Byte layer;
    Byte view;
    Byte group;
    Byte fSameR;
    Byte type;//长宽点杂质比锐化(check value)镜像(check,value)（1/2/3/4/5/6/7/8）
    Byte data[2];
}SenseGroupSetSize;

typedef struct WaveSendType
{
    Byte Algorithm;   //色选算法
    Byte layer;
    Byte view;
    Byte ch;
    Byte type; //波形的类形
}WaveSendType;

typedef struct waveTypeCalibration
{
    Byte Algorithm;   //色选算法
    Byte layer;
    Byte view;
    Byte ch;
    Byte waveType;      //波形的类形  08: 原始数据 09: 校正数据  0a：测试数据
    Byte dataType;     //数据类型 0：详细数据 1：压缩数据  2：相机调整
    Byte postion;      // 0-100
}waveTypeCalibration;

typedef struct WaveHsv
{
    Byte Algorithm;   //保留
    Byte layer;
    Byte view;
    Byte group;       //组
}WaveHsv;

typedef struct WaveTypeAlg
{
    Byte Algorithm;   //色选算法
    Byte layer;
    Byte view;
    Byte ch;
}WaveTypeAlg;
#endif /* common_struct_h */
