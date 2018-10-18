//
//  Rice1RColorAdvancedView.m
//  thColorSort
//
//  Created by huanghu on 2018/2/27.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "Rice1RColorAdvancedView.h"
#import "Rice20SenseSizeTableViewCell.h"
#import "LGJFoldHeaderView.h"
#import "WaveDataTableViewCell.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
#import "TableViewCellWithDefaultTitleLabel1Lable.h"
static NSString *CellIdentifier = @"WaveDataTableViewCell";
static NSString *senseCellIdentifier = @"TableViewCellWithDefaultTitleLabel1TextField";
static NSString *senseCellTitleIdentifier = @"TableViewCellWithDefaultTitleLabel1Lable";
@interface Rice1RColorAdvancedView()<UITableViewDataSource,UITableViewDelegate,TableViewCellChangedDelegate,FoldSectionHeaderViewDelegate>
{
    BOOL dataLoaded;
    Byte waveType;
    Byte currentGroup;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSTimer *timer;
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@property (strong, nonatomic) IBOutlet UILabel *useLabel;
@property (strong, nonatomic) IBOutlet UISwitch *UseSwitch;
@end
@implementation Rice1RColorAdvancedView


- (IBAction)useSwitchValueChanged:(UISwitch *)sender {
    [gNetwork sendToChangeUseStateWithAlgorithm:self.type IsIR:0];
    if (sender.isOn) {
        [self.useLabel setText:kLanguageForKey(35)];
    }else{
        [self.useLabel setText:kLanguageForKey(36)];
    }
}

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"RiceColorAdvancedView" owner:self options:nil] firstObject];
        self.tableView.dataSource =self;
        self.tableView.delegate =self;
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        waveType = wave_rgb;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
        dataLoaded = false;
        _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                       @"0":@"0",
                                                                       @"1":@"0",
                                                                       @"2":@"0",
                                                                       }];
        
        [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:senseCellIdentifier bundle:nil] forCellReuseIdentifier:senseCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:senseCellTitleIdentifier bundle:nil] forCellReuseIdentifier:senseCellTitleIdentifier];
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        currentGroup = 0;
        
    }
    
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    if (para) {
        Device *device = kDataModel.currentDevice;
        NSString *index = [para valueForKey:@"algorithmIndex"];
        self.algorithmIndex = index.intValue;
        self.type = (*(device->colorAlgorithm+self.algorithmIndex)).type;
    }
    [self refreshCurrentView];
    return self;
}
-(void)refreshCurrentView{
    [[NetworkFactory sharedNetWork]sendToGetRiceEngineerAdvancedSenseWithType:self.type];
}

-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x04) {
        if (header[1] == 0x03) {
            dataLoaded = true;
            if ((*(kDataModel.currentDevice->colorAlgorithm+(int)_algorithmIndex)).used == 1)
            {
                [self.UseSwitch setOn:YES];
                [self.useLabel setText:kLanguageForKey(35)];
            }
            else
            {
                [self.UseSwitch setOn:NO];
                [self.useLabel setText:kLanguageForKey(36)];
            }
            [self.tableView reloadData];
        }
        if (header[1] == 0x04) {
            (*(kDataModel.currentDevice->colorAlgorithm+(int)_algorithmIndex)).used = header[4];
        }
        if (header[1] == 0x02) {
            [[NetworkFactory sharedNetWork]sendToGetRiceEngineerAdvancedSenseWithType:self.type];
        }
        if (header[1] == 0x06|| header[1] == 0x25) {
            [self.tableView reloadData];
        }
    }else if (header[0] == 0x05) {
        if (_timer.isValid) {
            Device *device = kDataModel.currentDevice;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
            WaveDataTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            for (int i = 0; i<device->waveDataCount; i++) {
                [cell bindWaveData:device->waveData[i] withIndex:i];
            }
            [cell bindWaveColorType:(Byte*)(&(device->waveType)) andColorDiffLightType:waveType andAlgriothmType:_type];
            
        }
    }else if (header[0] == 0x55) {
        if (_timer.isValid) {
            [_timer invalidate];
        }
        [super updateWithHeader:headerData];
    }else if (header[0]  == 0xb0){
        [self refreshCurrentView];
    }
}


-(BOOL)Back
{
    if (_timer.valid) {
        [_timer invalidate];
    }
    return [super Back];
}

-(void)networkError:(NSError *)error{
    if (_timer.valid) {
        [_timer invalidate];
    }
    [super networkError:error];
}
#pragma tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataLoaded) {
        return 3;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    if (dataLoaded) {
        Device *device = kDataModel.currentDevice;
        if (section == 0) {
            return device->groupNum+1;
        }
        if (section == 1) {
            return 1;
        }
        if (section == 2) {
            return folded?1:0;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 40;
    }
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
    }
    
    if (section == 0) {
        [headerView setHidden:NO];
    } else if (section == 1) {
        [headerView setHidden:NO];
    } else if (section == 2){
        LGJFoldHeaderView *lgheaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LGheader"];
        if (!lgheaderView) {
            lgheaderView = [[LGJFoldHeaderView alloc]initWithReuseIdentifier:@"LGheader"];
        }
        [lgheaderView setFoldSectionHeaderViewWithTitle:kLanguageForKey(42)  detail:@"" type:HerderStyleTotal section:2 canFold:YES];
        lgheaderView.delegate = self;
        NSString *key = [NSString stringWithFormat:@"%d", (int)section];
        BOOL folded = [[_foldInfoDic valueForKey:key] boolValue];
        lgheaderView.fold = folded;
        return lgheaderView;
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 203;
        }else{
            return 50;
        }
    }
    if (indexPath.section == 2) {
        CGFloat width =[UIScreen mainScreen].bounds.size.width-40;
        CGFloat height = (width-40)*0.618+60;
        return height;
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            TableViewCellWithDefaultTitleLabel1Lable *cell = [tableView dequeueReusableCellWithIdentifier:senseCellTitleIdentifier forIndexPath:indexPath];
            cell.senseValueTitleLabel.text = kLanguageForKey(14);
            cell.senseValueTitleLabel.font = SYSTEMFONT_14f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row<device->groupNum+1){
            TableViewCellWithDefaultTitleLabel1TextField *cell = [tableView dequeueReusableCellWithIdentifier:senseCellIdentifier forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.cellType = TableViewCellType_RiceGroupColorSense;
            if (indexPath.row == 1){
                cell.textLabel.textColor = [UIColor Group1Color];
                cell.textLabel.text = kLanguageForKey(331);
            }
            if (indexPath.row == 2){
                cell.textLabel.textColor = [UIColor Group2Color];
                cell.textLabel.text = kLanguageForKey(332);
            }
            
            cell.textField.text = [NSString stringWithFormat:@"%d",device->data1[indexPath.row-1]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//设置杂质大小
            static NSString *cellIdentifier = @"Rice20SenseSizeTableViewCell";
            Rice20SenseSizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            
            cell.sizeTitleLabel.text = kLanguageForKey(40) ;
            cell.lengthTitleLabel.text = kLanguageForKey(37) ;
            cell.widthTitleLabel.text = kLanguageForKey(38) ;
            cell.sizeTitleLabel.text = kLanguageForKey(39) ;
            
            
            cell.lengthTextField.text=[NSString stringWithFormat:@"%d", device->groupSenseLength[currentGroup]];
            cell.widthTextField.text = [NSString stringWithFormat:@"%d",device->groupSenseWidth[currentGroup]];
            cell.sizeTextField.text = [NSString stringWithFormat:@"%d",device->groupSenseSize[currentGroup][0]*256+device->groupSenseSize[currentGroup][1]];
            
            if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
                cell.frontRearTitleLabel.hidden = NO;
                cell.frontRearCheckbtn.hidden = NO;
            }else{
                cell.frontRearTitleLabel.hidden = YES;
                cell.frontRearCheckbtn.hidden = YES;
            }
            cell.frontRearTitleLabel.text = kLanguageForKey(43) ;
            if (device->sense.fSameR) {
                cell.frontRearCheckbtn.selected = YES;
            }else{
                cell.frontRearCheckbtn.selected = NO;
            }
            
            [cell updateSharpenHidden:YES];
            [cell updateMirrorHidden:YES];
            
            cell.groupNum = device->groupNum;
            cell.currentGroupIndex = currentGroup;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            WaveDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.chuteTitleLabel.text = kLanguageForKey(41) ;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.chuteNumCount = device->machineData.chuteNumber;
            for (int i = 0; i<device->waveDataCount; i++) {
                [cell bindWaveData:device->waveData[i] withIndex:i];
            }
            [cell bindWaveColorType:(Byte*)(&(device->waveType)) andColorDiffLightType:waveType andAlgriothmType:_type];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}
#pragma table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma foldHeaderSectionDelegate

- (void)foldHeaderInSection:(NSInteger)SectionHeader
{
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    NSString *fold = folded ? @"0" : @"1";
    [_foldInfoDic setValue:fold forKey:key];
    if (!folded) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
    }
    else
    {
        [_timer invalidate];
    }
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:SectionHeader];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    if (!folded) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)timeout
{
    [[NetworkFactory sharedNetWork]sendToGetWaveDataWithAlgorithmType:_type AndWaveType:waveType AndDataType:0 Position:0];
}

#pragma tableview cell delegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    if (section == 0)
    {
            [[NetworkFactory sharedNetWork]sendAlgorithmSenseValueWithAjustType:0 Sorter:1 data:value algorithmType:_type FirstSecond:row-1 ValueType:1 IsIR:0];
    }else if (section == 1) {
        if(row == 0){
            if (index < 9) {
                [gNetwork sendToChangeRiceEnineerSenseSizeWithAlgorithmType:self.type Group:currentGroup Type:index Value:value];
            }else if (index == 9){
                device->sense.fSameR = value;
            }else if (index == 10){
                currentGroup = value;
                [self.tableView reloadData];
            }
        }
    }else if (section == 2){
        device.currentSorterIndex = value;
    }
}


-(void)cellBtnClicked:(long)section row:(long)row tag:(long)tag value:(NSInteger)value bSend:(BOOL)bsend{

}

-(void)reloadRows{
    Device *device = kDataModel.currentDevice;
    NSArray *rowArray =[NSArray array];
    for (int i= 1; i<=device->machineData.chuteNumber;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        rowArray  = [rowArray arrayByAddingObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationNone];
}
-(void)dealloc{
    NSLog(@"colorAdvanced view dealloc");
}


@end
