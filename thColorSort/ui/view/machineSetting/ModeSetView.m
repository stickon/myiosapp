//
//  ModeSetView.m
//  thColorSort
//
//  Created by huanghu on 2018/1/11.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "ModeSetView.h"
#import "TableViewCellWithDefaultTitleLabel1Switch.h"
#import "TableViewCellWith1Label1Switch.h"
#import "UITableViewHeaderFooterViewWith1Switch.h"

#import "TableViewCellWith1Segment1Label.h"
#import "LGJFoldHeaderView.h"
#import "TipsView.h"
#import "SelectItemTableView.h"
static NSString *switchTableViewCell = @"TableViewCellWith1Label1Switch";
static NSString *headerViewIdentifier = @"rowHeaderViewCellIdentifier";
static NSString *segmentedTableViewCellIdentifier = @"TableViewCellWith1Segment1Label";
static NSString *foldHeaderViewIdentifier = @"LGJFoldHeaderView";
static NSString *defaultTitleWith1SwitchTableViewCell = @"TableViewCellWithDefaultTitleLabel1Switch";

@interface ModeSetView()<UITableViewDelegate,UITableViewDataSource,SwitchHeaderViewDelegate,TableViewCellChangedDelegate,FoldSectionHeaderViewDelegate,TipsViewResultDelegate,SelectItemDelegate>
{
    Mode *tempMode;
    BOOL isLoadDataComplete;//数据是否通过网络获取到
}
@property (assign,nonatomic) Byte modeIndex;
@property (assign,nonatomic) Byte bigModeIndex;
@property (assign,nonatomic) Byte isExpertMode;//是否为专家方案
@property (strong, nonatomic) TipsView *tipsView;
@property (strong, nonatomic) SelectItemTableView *selectItemView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) Byte frontRearInCommon;// 1 true  0 false
@property (assign,nonatomic) Byte tempUseSvm;//是否使用svm
@property (assign,nonatomic) Byte tempUseHsv;//是否使用hsv
@property (assign,nonatomic) Byte tempShapeIndex;//形选索引（暂时不提供更改)
@property (nonatomic,strong) NSIndexPath* selectIndexPath;
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@property (strong,nonatomic) NSArray* colorDiffArray;
@property (strong,nonatomic) NSArray* colorArray;
@property (strong,nonatomic) NSArray* irArray;
@property (strong,nonatomic) NSArray* irDiffArray;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerHeightconstraint;
@property (strong, nonatomic) IBOutlet UIButton *applyBtn;
@end
@implementation ModeSetView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ModeSetView" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        tempMode = NULL;
        isLoadDataComplete = false;
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerNib:[UINib nibWithNibName:switchTableViewCell bundle:nil] forCellReuseIdentifier:switchTableViewCell];
        [self.tableView registerNib:[UINib nibWithNibName:switchTableViewCell bundle:nil] forCellReuseIdentifier:headerViewIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:segmentedTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:segmentedTableViewCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:defaultTitleWith1SwitchTableViewCell bundle:nil] forCellReuseIdentifier:defaultTitleWith1SwitchTableViewCell];
    }
    return self;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    if (para) {
        NSString *bigModeIndex = [para valueForKey:@"bigModeIndex"];
        self.bigModeIndex = bigModeIndex.intValue;
        NSString *smallModeIndex = [para valueForKey:@"smallModeIndex"];
        self.modeIndex = smallModeIndex.intValue;
    }
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
        
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerHeightconstraint.constant = 0.0;
    }
    if (self.modeIndex == device->machineData.sortModeSmall && self.bigModeIndex == device->machineData.sortModeBig) {
        [self.applyBtn setEnabled:true];
    }else{
        [self.applyBtn setEnabled:false];
    }
    [[NetworkFactory sharedNetWork]getModeSettingWithIndex:self.modeIndex BigModeIndex:self.bigModeIndex];
    [self initLanguage];
    return self;
}
- (void)initLanguage{
    [super initLanguage];
    [self.applyBtn setTitle:kLanguageForKey(113) forState:UIControlStateNormal];
    
    _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"1":@"0",@"2":@"0",}];
    
    NSString *redThanGreen = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(47),kLanguageForKey(49)];
    NSString *redThanBlue = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(47),kLanguageForKey(48)];
    NSString *greenThanRed = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(49),kLanguageForKey(47)];
    NSString *greenThanBlue = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(49),kLanguageForKey(48)];
    NSString *blueThanRed = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(48),kLanguageForKey(47)];
    NSString *blueThanGreen = [NSString stringWithFormat:@"%@>%@",kLanguageForKey(48),kLanguageForKey(49)];
    _colorDiffArray = @[redThanGreen,redThanBlue,greenThanRed,greenThanBlue,blueThanRed,blueThanGreen];
    
    NSString *redGreen = [NSString stringWithFormat:@"%@+%@",kLanguageForKey(47),kLanguageForKey(49)];
    NSString *redBlue = [NSString stringWithFormat:@"%@+%@",kLanguageForKey(47),kLanguageForKey(48)];
    NSString *greenBlue = [NSString stringWithFormat:@"%@+%@",kLanguageForKey(49),kLanguageForKey(48)];
    NSString *redGreenBlue = [NSString stringWithFormat:@"%@+%@+%@",kLanguageForKey(47),kLanguageForKey(49),kLanguageForKey(48)];
    _colorArray = @[kLanguageForKey(47),kLanguageForKey(49),kLanguageForKey(48),redGreen,redBlue,greenBlue,redGreenBlue];
    NSString *irstring1 = [NSString stringWithFormat:@"%@%d",kLanguageForKey(104),1];
    NSString *irstring2 = [NSString stringWithFormat:@"%@%d",kLanguageForKey(104),2];
    _irArray = @[irstring1,irstring2];
    NSString *irCompareString1 = [NSString stringWithFormat:@"%@>%@",irstring1,irstring2];
    NSString *irCompareString2 = [NSString stringWithFormat:@"%@<%@",irstring1,irstring2];
    _irDiffArray = @[irCompareString1,irCompareString2];
}
- (void)updateWithHeader:(NSData *)headerData{
    const unsigned char *a  = headerData.bytes;
    if (a[0] == 0x0d) {
        if (a[1] == 0x04) {
            if (a[2] == 1) {
                [[NetworkFactory sharedNetWork] getCurrentDeviceInfo];
                [self makeToast: kLanguageForKey(91) duration:2.0 position:CSToastPositionCenter];
            }else{
                [self makeToast: kLanguageForKey(92) duration:2.0 position:CSToastPositionCenter];
            }
            [[NetworkFactory sharedNetWork] getModeSettingWithIndex:self.modeIndex BigModeIndex:self.bigModeIndex];
        }else if(a[1] == 0x03){
            int modeLength = a[2]*sizeof(Mode);
            if (!mode) {
                mode = malloc(modeLength);
            }
            NSLog(@"modelength:%d",modeLength);
            memcpy(mode, a+HeaderLength, modeLength);
            Device *device = kDataModel.currentDevice;
            if (!tempMode) {
                tempMode = malloc(device->machineData.layerNumber*sizeof(Mode));
            }
            memcpy(tempMode, mode, device->machineData.layerNumber*sizeof(Mode));
            shape = a[HeaderLength+modeLength];
            useSvm = a[HeaderLength+modeLength+1];
            useHsv = a[HeaderLength+modeLength+2];
            self.tempUseSvm = useSvm;
            self.tempShapeIndex = shape;
            self.tempUseHsv = useHsv;
            isLoadDataComplete = true;
            [self.tableView reloadData];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getModeSettingWithIndex:self.modeIndex BigModeIndex:self.bigModeIndex];
    }
}

- (IBAction)btnClicked:(UIButton *)sender {
    Device *device = kDataModel.currentDevice;
    
    if (sender.tag == 100) {
        if (device->machineData.startState == 1) {
            [self makeToast:kLanguageForKey(93) duration:2.0 position:CSToastPositionCenter];
        }else{
             NSInteger modeLength = (device->machineData.layerNumber)*sizeof(Mode);
            [[NetworkFactory sharedNetWork] changeModeSettingWithMode:(Byte*)tempMode shape:_tempShapeIndex svm:_tempUseSvm hsv:self.tempUseHsv ModeLength:modeLength];
            
        }
            }
}

#pragma mark - tableview datasource
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y > 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if (scrollView.contentOffset.y >= sectionHeaderHeight){
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 6 ||section == 5) {
        return 0;
    }else
        return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LGJFoldHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:foldHeaderViewIdentifier];
    if (!header) {
        header = [[LGJFoldHeaderView alloc]initWithReuseIdentifier:foldHeaderViewIdentifier];
    }
    if (section == 1) {
        NSString *normalCameraTitle =kLanguageForKey(175);
        [header setFoldSectionHeaderViewWithTitle:normalCameraTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
        
    }else if (section == 2) {
        NSString *irCameraTitle = kLanguageForKey(176);
        [header setFoldSectionHeaderViewWithTitle:irCameraTitle detail:@"" type:HerderStyleTotal section:section canFold:YES];
    }
    else{
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        }
        return headerView;
    }
    header.delegate = self;
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL folded = [[_foldInfoDic valueForKey:key]boolValue];
    header.fold = folded;
    return header;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    Device *device = kDataModel.currentDevice;
    if (isLoadDataComplete) {
        NSInteger section = 2;
        if (device->machineData.useIR) {
            section++;
        }
        return section;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
    
    Device *device = kDataModel.currentDevice;
    if (section == 0) {
        if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
            return 5;
        }else
            return 3;
    }else if(section == 1){
        return folded?17:0;
    }else if (section == 2 ){
        NSInteger rowCount;
        if (device->machineData.useIR<4) {//单红外
            rowCount = 3;
        }else{
            rowCount =6;
        }
        return folded?rowCount:0;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = kLanguageForKey(115);
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            if (self.tempShapeIndex>=0 &&self.tempShapeIndex<=22) {
                cell.detailTextLabel.text = [self.shapeArray objectAtIndex:self.tempShapeIndex];
            }else{
                [self makeToast:@"shape index error" duration:2.0 position:CSToastPositionCenter];
            }
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell.detailTextLabel.textColor = [UIColor redColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            TableViewCellWithDefaultTitleLabel1Switch *cell = [tableView  dequeueReusableCellWithIdentifier:defaultTitleWith1SwitchTableViewCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.textLabel.textColor = [UIColor blackColor];
            if (indexPath.row == 1) {
                cell.textLabel.text = kLanguageForKey(31);
                NSLog(@"tempusesvm:%d",self.tempUseSvm);
                [cell.switchBtn setOn:self.tempUseSvm];
            }
            else if (indexPath.row == 2) {
                cell.textLabel.text =  kLanguageForKey(114);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.switchBtn setOn:tempMode[layerIndex].FrontRearRelation];
            }else if(indexPath.row == 3){
                cell.textLabel.text =  kLanguageForKey(43);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.switchBtn setOn:self.frontRearInCommon];
            }else if (indexPath.row == 4){
                cell.textLabel.text = kLanguageForKey(338);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.switchBtn setOn:self.tempUseHsv];
            }
            return cell;
        }
        
    }else if(indexPath.section == 1){//可见算法
        if (indexPath.row == 0) {
            TableViewCellWith1Segment1Label *frontRearViewCell = [tableView dequeueReusableCellWithIdentifier:segmentedTableViewCellIdentifier forIndexPath:indexPath];
            frontRearViewCell.delegate = self;
            frontRearViewCell.indexPath = indexPath;
            if (device->machineData.hasRearView[device.currentLayerIndex-1]) {//前后视都有
                [frontRearViewCell.frontRearViewSegmentedControl setHidden:NO];
                [frontRearViewCell.frontViewLabel setHidden:YES];
                [frontRearViewCell.frontRearViewSegmentedControl setTitle:kLanguageForKey(75) forSegmentAtIndex:0];
                [frontRearViewCell.frontRearViewSegmentedControl setTitle:kLanguageForKey(76) forSegmentAtIndex:1];
            }else{//没有后视
                [frontRearViewCell.frontRearViewSegmentedControl setHidden:YES];
                [frontRearViewCell.frontViewLabel setHidden:NO];
                frontRearViewCell.frontViewLabel.text = kLanguageForKey(75);
            }
            frontRearViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return frontRearViewCell;
        }else if (indexPath.row == 1 ||indexPath.row == 5 ||indexPath.row ==9|| indexPath.row == 12 || indexPath.row == 15 ) {
            TableViewCellWith1Label1Switch *cell = [tableView dequeueReusableCellWithIdentifier:headerViewIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.alignment = CellLabelCenterAlignMent;
            cell.titleTextLabel.textColor = [UIColor TaiheColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                [cell.switchBtn setHidden:YES];
                cell.titleTextLabel.text = kLanguageForKey(122);
            }else if (indexPath.row == 5){
                [cell.switchBtn setHidden:YES];
                cell.titleTextLabel.text = kLanguageForKey(123);
            }else if (indexPath.row == 9){
                [cell.switchBtn setHidden:NO];
                [cell setSwitchBtnState:tempMode[layerIndex].diff1[viewIndex][0]];
                NSString *title = [NSString stringWithFormat:@"%@%d",kLanguageForKey(120),1];
                cell.titleTextLabel.text = title;
            }else if (indexPath.row == 12){
                [cell.switchBtn setHidden:NO];
                [cell setSwitchBtnState:tempMode[layerIndex].diff2[viewIndex][0]];
                NSString *title = [NSString stringWithFormat:@"%@%d",kLanguageForKey(120),2];
                cell.titleTextLabel.text = title;
            }else if (indexPath.row == 15){
                cell.switchBtn.hidden = NO;
                [cell setSwitchBtnState:tempMode[layerIndex].lightLimit[viewIndex]];
                cell.titleTextLabel.text = kLanguageForKey(265);
            }
            
            return cell;
        }
        else if (indexPath.row == 2 || indexPath.row == 3||indexPath.row == 6 ||indexPath.row == 7) {
            
            TableViewCellWith1Label1Switch *cell = [tableView dequeueReusableCellWithIdentifier:switchTableViewCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath  = indexPath;
            cell.alignment = CellLabelLeftAlignment;
            cell.titleTextLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 2) {
                cell.titleTextLabel.text =  kLanguageForKey(116);
                [cell setSwitchBtnState:tempMode[layerIndex].rgbSpot[viewIndex][0]];
            }else if (indexPath.row == 3){
                cell.titleTextLabel.text =  kLanguageForKey(117);
                [cell setSwitchBtnState:tempMode[layerIndex].rgbSpot[viewIndex][1]];
            }else if (indexPath.row == 6){
                cell.titleTextLabel.text =  kLanguageForKey(124);
                [cell setSwitchBtnState:tempMode[layerIndex].rgbArea[viewIndex][0]];
            }else if (indexPath.row == 7){
                cell.titleTextLabel.text =  kLanguageForKey(125);
                [cell setSwitchBtnState:tempMode[layerIndex].rgbArea[viewIndex][1]];
            }
//            else if (indexPath.row == 17){
//                cell.switchBtn.hidden = NO;
//                [cell setSwitchBtnState:tempMode[layerIndex].UseRiceReverse];
//                cell.titleTextLabel.text = kLanguageForKey(386);
//            }else if (indexPath.row == 18){
//                cell.switchBtn.hidden = NO;
//                [cell setSwitchBtnState:tempMode[layerIndex].UseRiceWhite];
//                cell.titleTextLabel.text = kLanguageForKey(389);
//            }
            return cell;
        }else if(indexPath.row == 4 ||indexPath.row == 8 ||indexPath.row == 10 ||indexPath.row == 11|| indexPath.row == 13||indexPath.row == 14 ||indexPath.row == 16){
            UITableViewCell *textCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            textCell.selectionStyle = UITableViewCellSelectionStyleNone;
            textCell.textLabel.font = [UIFont systemFontOfSize:15.0];
            textCell.textLabel.tintColor = [UIColor grayColor];
            NSString *colorStr = nil;
            if (indexPath.row == 4) {
                
                NSInteger index = tempMode[layerIndex].rgbSpotColor[viewIndex];
                if (index<= 6&&index>=0) {
                    colorStr = [self.colorArray objectAtIndex:tempMode[layerIndex].rgbSpotColor[viewIndex]];
                }else{
                    @throw @"";
                    //fix me
                }
                
                
                textCell.textLabel.text = kLanguageForKey(46);
                
            }else if(indexPath.row == 8){
                colorStr = [self.colorArray objectAtIndex:tempMode[layerIndex].rgbAreaColor[viewIndex]];
                NSLog(@"区域:%d",tempMode[layerIndex].rgbAreaColor[viewIndex]);
                textCell.textLabel.text = kLanguageForKey(46);
                
            }else if (indexPath.row == 10){
                textCell.textLabel.text =  kLanguageForKey(46);
                NSLog(@"色差1color:%d",tempMode[layerIndex].diff1[viewIndex][1]);
                colorStr = [self.colorDiffArray objectAtIndex:tempMode[layerIndex].diff1[viewIndex][1]];
            }else if(indexPath.row == 11) {
                textCell.textLabel.text = kLanguageForKey(45);
                colorStr = [self.colorArray objectAtIndex:tempMode[layerIndex].diff1[viewIndex][2]];
                NSLog(@"色差1亮度:%d",tempMode[layerIndex].diff1[viewIndex][2]);
            }else if(indexPath.row == 13) {
                textCell.textLabel.text =  kLanguageForKey(46);
                colorStr = [self.colorDiffArray objectAtIndex:tempMode[layerIndex].diff2[viewIndex][1]];
            }else if (indexPath.row == 14) {
                textCell.textLabel.text = kLanguageForKey(45);
                colorStr = [self.colorArray objectAtIndex:tempMode[layerIndex].diff2[viewIndex][2]];
            }else if (indexPath.row == 16){
                textCell.textLabel.text = kLanguageForKey(46);
                colorStr = [self.colorArray objectAtIndex:tempMode[layerIndex].lightLimitColor[viewIndex]];
            }
            textCell.detailTextLabel.text = colorStr;
            textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return textCell;
        }
    }else if (indexPath.section == 2){//红外算法
        if (indexPath.row == 0) {
            TableViewCellWith1Segment1Label *frontRearViewCell = [tableView dequeueReusableCellWithIdentifier:segmentedTableViewCellIdentifier forIndexPath:indexPath];
            frontRearViewCell.delegate = self;
            frontRearViewCell.indexPath = indexPath;
            if (device->machineData.useIR%3 == 0) {//前后都有
                [frontRearViewCell.frontRearViewSegmentedControl setHidden:NO];
                [frontRearViewCell.frontRearViewSegmentedControl setTitle:kLanguageForKey(75) forSegmentAtIndex:0];
                [frontRearViewCell.frontRearViewSegmentedControl setTitle:kLanguageForKey(76) forSegmentAtIndex:1];
                [frontRearViewCell.frontViewLabel setHidden:YES];
            }else{//单视
                [frontRearViewCell.frontRearViewSegmentedControl setHidden:YES];
                [frontRearViewCell.frontViewLabel setHidden:NO];
                if (device->machineData.useIR%3== 1) {//仅前视
                    frontRearViewCell.frontViewLabel.text = kLanguageForKey(75);
                }else if (device->machineData.useIR%3== 2) {//仅后视
                    frontRearViewCell.frontViewLabel.text = kLanguageForKey(76);
                }
            }
            frontRearViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return frontRearViewCell;
        }else if (indexPath.row == 1 ||indexPath.row == 2 ||indexPath.row ==4) {
            TableViewCellWith1Label1Switch *cell = [tableView dequeueReusableCellWithIdentifier:switchTableViewCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.alignment = CellLabelLeftAlignment;
            //            [cell.contentView setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.3]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                [cell.switchBtn setHidden:NO];
                cell.titleTextLabel.text = kLanguageForKey(177);
                [cell setSwitchBtnState:tempMode[layerIndex].irRgb[viewIndex][0]];
            }else if (indexPath.row == 2){
                [cell.switchBtn setHidden:NO];
                cell.titleTextLabel.text = kLanguageForKey(178);
                [cell setSwitchBtnState:tempMode[layerIndex].irRgb[viewIndex][1]];
            }else if (indexPath.row == 4){
                [cell.switchBtn setHidden:NO];
                cell.titleTextLabel.text = kLanguageForKey(179);
                [cell setSwitchBtnState:tempMode[layerIndex].irDiff[viewIndex]];
            }
            return cell;
        }else if (indexPath.row == 3 ||indexPath.row == 5){
            UITableViewCell *textCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            textCell.selectionStyle = UITableViewCellSelectionStyleNone;
            textCell.textLabel.font = [UIFont systemFontOfSize:15.0];
            textCell.textLabel.tintColor = [UIColor grayColor];
            NSString *colorStr = nil;
            if (indexPath.row == 3) {
                colorStr = [self.irArray objectAtIndex:tempMode[layerIndex].irRgbColor[viewIndex]];
                
            }else if(indexPath.row == 5){
                colorStr = [self.irDiffArray objectAtIndex:tempMode[layerIndex].irDiffColor[viewIndex]];
                
            }
            textCell.textLabel.text = kLanguageForKey(46);
            textCell.detailTextLabel.text = colorStr;
            textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return textCell;
        }
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}

#pragma foldsectiondelegate

-(void)foldHeaderInSection:(NSInteger)SectionHeader
{
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[_foldInfoDic objectForKey:key]boolValue];
    NSString *fold = folded?@"0":@"1";
    [_foldInfoDic setValue:fold forKey:key];
    
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc]initWithIndex:SectionHeader];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark -table delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndexPath = [indexPath copy];
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (indexPath.section == 1) {
        if (indexPath.row == 4 ||indexPath.row == 8|| indexPath.row == 10|| indexPath.row == 11||indexPath.row == 13|| indexPath.row == 14 || indexPath.row == 16){
            if (indexPath.row == 4) {
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].rgbSpotColor[viewIndex]];
            }else if (indexPath.row == 8){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].rgbAreaColor[viewIndex]];
            }else if (indexPath.row == 10){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorDiffArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].diff1[viewIndex][1]];
            }else if (indexPath.row == 11){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].diff1[viewIndex][2]];
            }else if (indexPath.row == 13){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorDiffArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].diff2[viewIndex][1]];
            }else if (indexPath.row == 14){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].diff2[viewIndex][2]];
            }else if (indexPath.row == 16){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.colorArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].lightLimitColor[viewIndex]];
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 3) {
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.irArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].irRgbColor[viewIndex]];
            }else if (indexPath.row == 5){
                [self.selectItemView showInView:self withFrame:self.frame itemArray:self.irDiffArray CurrentIndexPath:self.selectIndexPath CurrentRow:tempMode[layerIndex].irDiffColor[viewIndex]];
            }
        }
    }
}


#pragma mark - Navigation

#pragma mark SelectItemDelegate

-(void)selectItemWithIndexPath:(NSIndexPath *)indexPath itemIndex:(Byte)index{//选择颜色种类
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (indexPath.section == 1) {
        if (indexPath.row == 4) {
            if (self.frontRearInCommon) {
                tempMode[layerIndex].rgbSpotColor[0]= index;
                tempMode[layerIndex].rgbSpotColor[1]= index;
            }else{
                tempMode[layerIndex].rgbSpotColor[viewIndex]= index;
            }
        }else if (indexPath.row == 8) {
            if (self.frontRearInCommon) {
                tempMode[layerIndex].rgbAreaColor[0] = index;
                tempMode[layerIndex].rgbAreaColor[1] = index;
            }else{
                tempMode[layerIndex].rgbAreaColor[viewIndex] = index;
            }
        }else if(indexPath.row == 10){
            if (self.frontRearInCommon) {
                tempMode[layerIndex].diff1[0][1] = index;
                tempMode[layerIndex].diff1[1][1] = index;
            }else{
                tempMode[layerIndex].diff1[viewIndex][1] = index;
            }
        }else if (indexPath.row == 11){
            if (self.frontRearInCommon) {
                tempMode[layerIndex].diff1[0][2] = index;
                tempMode[layerIndex].diff1[1][2] = index;
            }else{
                tempMode[layerIndex].diff1[viewIndex][2] = index;
            }
        }else if(indexPath.row == 13){
            if (self.frontRearInCommon) {
                tempMode[layerIndex].diff2[0][1] = index;
                tempMode[layerIndex].diff2[1][1] = index;
            }else{
                tempMode[layerIndex].diff2[viewIndex][1] = index;
            }
        }else if (indexPath.row == 14){
            if (self.frontRearInCommon) {
                tempMode[layerIndex].diff2[0][2] = index;
                tempMode[layerIndex].diff2[1][2] = index;
            }else{
                tempMode[layerIndex].diff2[viewIndex][2] = index;
            }
        }else if (indexPath.row == 16){
            if (self.frontRearInCommon) {
                tempMode[layerIndex].lightLimitColor[0] = index;
                tempMode[layerIndex].lightLimitColor[1] = index;
            }else{
                tempMode[layerIndex].lightLimitColor[viewIndex] = index;
            }
        }
    }
    else if (indexPath.section == 2){
        if(indexPath.row == 3){
            if (self.frontRearInCommon) {
                tempMode[layerIndex].irRgbColor[0] = index;
                tempMode[layerIndex].irRgbColor[1] = index;
            }else{
                tempMode[layerIndex].irRgbColor[viewIndex] = index;
            }
        }else if (indexPath.row == 5){
            if (self.frontRearInCommon) {
                tempMode[layerIndex].irDiffColor[0] = index;
                tempMode[layerIndex].irDiffColor[1] = index;
            }else{
                tempMode[layerIndex].irDiffColor[viewIndex] = index;
            }
        }
    }
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark switchbtn relate to

#pragma mark - SwitchHeaderViewDelegate
-(void)switchHeaderInSection:(NSInteger)section withSwitchState:(Byte)state{
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (section == 3) {
        tempMode[layerIndex].diff1[viewIndex][0] = state;
    }else if(section == 4){
        tempMode[layerIndex].diff1[viewIndex][0] = state;
    }else if (section == 5){
        device->shape = state;
    }
}

#pragma mark - tableviewcellchanged delegate

-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{//使能
    Device *device = kDataModel.currentDevice;
    int viewIndex = device.currentViewIndex;
    int layerIndex = device.currentLayerIndex-1;
    if (section == 0) {
        if (row == 1) {
            self.tempUseSvm = value;
            if (value) {
                self.tempUseHsv = 0;
                [self.tableView reloadData];
            }
        }else if (row == 2) {
            tempMode[layerIndex].FrontRearRelation = value;
        }else if (row == 3){
            self.frontRearInCommon = value;
        }else if (row == 4){
            self.tempUseHsv = value;
            if (value) {
                self.tempUseSvm = 0;
                [self.tableView reloadData];
            }
        }
    }else if (section == 1){
        if (row == 0) {
            device.currentViewIndex = value;
            [self.tableView reloadData];
        }else if(row == 2)
        {
            if (_frontRearInCommon) {
                tempMode[layerIndex].rgbSpot[0][0] = value;
                tempMode[layerIndex].rgbSpot[1][0] = value;
            }else{
                tempMode[layerIndex].rgbSpot[viewIndex][0] = value;
            }
        }else if (row == 3){
            if (_frontRearInCommon) {
                tempMode[layerIndex].rgbSpot[0][1] = value;
                tempMode[layerIndex].rgbSpot[1][1] = value;
            }else{
                tempMode[layerIndex].rgbSpot[viewIndex][1] = value;
            }
        }else if (row == 6) {
            if (_frontRearInCommon) {
                tempMode[layerIndex].rgbArea[0][0] = value;
                tempMode[layerIndex].rgbArea[1][0] = value;
            }else{
                tempMode[layerIndex].rgbArea[viewIndex][0] =value;
            }
        }else if (row == 7){
            if (_frontRearInCommon) {
                tempMode[layerIndex].rgbArea[0][1] = value;
                tempMode[layerIndex].rgbArea[1][1] = value;
            }else{
                tempMode[layerIndex].rgbArea[viewIndex][1] = value;
            }
        }else if (row == 9){
            if (_frontRearInCommon) {
                tempMode[layerIndex].diff1[0][0] = value;
                tempMode[layerIndex].diff1[1][0] = value;
            }else{
                tempMode[layerIndex].diff1[viewIndex][0] = value;
            }
        }else if (row == 12){
            if (_frontRearInCommon) {
                tempMode[layerIndex].diff2[0][0] = value;
                tempMode[layerIndex].diff2[1][0] = value;
            }else{
                tempMode[layerIndex].diff2[viewIndex][0] = value;
            }
        }else if (row == 15){
            if (_frontRearInCommon) {
                tempMode[layerIndex].lightLimit[0] = value;
                tempMode[layerIndex].lightLimit[1] = value;
            }else{
                tempMode[layerIndex].lightLimit[viewIndex] = value;
            }
        }
    }else if (section == 2){
        if (row == 0) {
            device.currentViewIndex = value;
            [self.tableView reloadData];
        }else if (row == 1) {
            if (_frontRearInCommon) {
                tempMode[layerIndex].irRgb[0][0] = value;
                tempMode[layerIndex].irRgb[1][0] = value;
            }else{
                tempMode[layerIndex].irRgb[viewIndex][0] = value;
            }
            
        }else if (row == 2){
            if (_frontRearInCommon) {
                tempMode[layerIndex].irRgb[0][1] = value;
                tempMode[layerIndex].irRgb[1][1] = value;
            }else{
                tempMode[layerIndex].irRgb[viewIndex][0] = value;
            }
        }else if (row == 4){
            if (_frontRearInCommon) {
                tempMode[layerIndex].irDiff[0] = value;
                tempMode[layerIndex].irDiff[1] = value;
            }else{
                tempMode[layerIndex].irDiff[viewIndex] = value;
            }
        }
    }
}

-(BOOL)modeIsChanged{
    Device *device = kDataModel.currentDevice;
    if (tempMode == NULL) {
        return false;//没有返回方案
    }
    for (int layer = 0; layer<device->machineData.layerNumber; layer++) {
        for (int i = 0; i<2; i++) {
            for (int j= 0; j<2; j++) {
                if (mode[layer].rgbSpot[i][j] !=tempMode[layer].rgbSpot[i][j]){
                    return true;
                }
                if(mode[layer].rgbArea[i][j] != tempMode[layer].rgbArea[i][j]){
                    return true;
                }
                if(mode[layer].irRgb[i][j] != tempMode[layer].irRgb[i][j]) {
                    NSLog(@"%d %d",mode[layer].irRgb[i][j],tempMode[layer].irRgb[i][j] );
                    return true;
                }
            }
        }
        for (int i =0; i<2; i++) {
            for (int j= 0; j<3; j++) {
                if ((mode[layer].diff1[i][j] != tempMode[layer].diff1[i][j]) ||(mode[layer].diff2[i][j]!= tempMode[layer].diff2[i][j])) {
                    return true;
                }
            }
        }
        for (int i= 0; i<2; i++) {
            if ((mode[layer].rgbSpotColor[i]!=tempMode[layer].rgbSpotColor[i])\
                ||(mode[layer].rgbAreaColor[i]!= tempMode[layer].rgbAreaColor[i])\
                ||(mode[layer].irRgbColor[i]!= tempMode[layer].irRgbColor[i])\
                ||(mode[layer].irDiffColor[i]!= tempMode[layer].irDiffColor[i])\
                ||(mode[layer].lightLimit[i]!= tempMode[layer].lightLimit[i])\
                ||(mode[layer].lightLimitColor[i] != tempMode[layer].lightLimitColor[i])) {
                return true;
            }
        }
        if (mode[layer].FrontRearRelation != tempMode[layer].FrontRearRelation) {
            return true;
        }
        if (useSvm != self.tempUseSvm) {
            return true;
        }
        if (useHsv != self.tempUseHsv) {
            return true;
        }
    }
    return false;
}

-(BOOL)Back{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.startState) {
        return [super Back];
    }else{
        if ([self modeIsChanged]&& self.modeIndex == device->machineData.sortModeSmall && self.bigModeIndex == device->machineData.sortModeBig) {
            [self.tipsView showInView:self.window withFrame:CGRectMake(0, (self.frame.size.height-400)/2, self.frame.size.width, self.frame.size.height)];
            
        }else{
            return [super Back];
        }
    }
    return NO;
}

#pragma mark tipsview delegate

-(void)tipsViewResult:(Byte)value{
    Device *device = kDataModel.currentDevice;
    if (value) {
        NSInteger modeLength = (device->machineData.layerNumber)*sizeof(Mode);
        [[NetworkFactory sharedNetWork] changeModeSettingWithMode:(Byte*)tempMode shape:self.tempShapeIndex svm:self.tempUseSvm hsv:self.tempUseHsv ModeLength:modeLength];
    }else{
        [[NetworkFactory sharedNetWork]getModeSettingWithIndex:self.modeIndex BigModeIndex:self.bigModeIndex];
    }
}
-(TipsView*)tipsView{
    if (!_tipsView) {
        _tipsView = [[TipsView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2-130, self.bounds.size.height / 2-80, 260, 160) okTitle:kLanguageForKey(130) cancelTitle:kLanguageForKey(131) tips:kLanguageForKey(129)];
        _tipsView.delegate=self;
        _tipsView.backgroundColor=[UIColor whiteColor];
        _tipsView.layer.cornerRadius=10;
    }
    return _tipsView;
}

-(SelectItemTableView*)selectItemView{
    if(!_selectItemView){
        _selectItemView = [[SelectItemTableView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-100, self.bounds.size.height/2-140, 200, 280)];
        _selectItemView.delegate = self;
        _selectItemView.backgroundColor = [UIColor whiteColor];
        _selectItemView.layer.cornerRadius = 10;
    }
    return _selectItemView;
}
- (void)dealloc{
    if (tempMode) {
        free(tempMode);
        tempMode = NULL;
    }
    if (mode) {
        free(mode);
        mode = NULL;
    }
}

-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self.tableView reloadData];
}
@end
