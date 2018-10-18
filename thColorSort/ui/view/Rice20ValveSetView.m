//
//  Rice20ValveSetView.m
//  thColorSort
//
//  Created by huanghu on 2018/2/23.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "Rice20ValveSetView.h"
#import "Rice20ValveSetTableViewCell.h"
static NSString *Rice20ValveSetTableViewCellIdentifier = @"Rice20ValveSetTableViewCell";
@interface Rice20ValveSetView()<UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *valveType;
@property (nonatomic,assign) BOOL loadComplete;
@property (strong, nonatomic) NSIndexPath *selectPath;

@end

@implementation Rice20ValveSetView
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"Rice20ValveSetView" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:Rice20ValveSetTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:Rice20ValveSetTableViewCellIdentifier];
        self.loadComplete = false;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [[NetworkFactory sharedNetWork] getGroupValvePara];
        self.title = kLanguageForKey(18);
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    return self;
}
- (void)refreshCurrentView{
    [[NetworkFactory sharedNetWork] getGroupValvePara];
}
-(void)updateWithHeader:(NSData*)headerData
{
    self.loadComplete = true;
    const Byte* a = headerData.bytes;
    if (a[0]== 0x09 && (a[1] == 0x21)) {
        [self.tableView reloadData];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [self refreshCurrentView];
    }
}

#pragma tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Device *device = kDataModel.currentDevice;
    if (device) {
        return device->groupNum;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 215.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    Device *device = kDataModel.currentDevice;
    Rice20ValveSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Rice20ValveSetTableViewCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:Rice20ValveSetTableViewCellIdentifier owner:self options:nil]lastObject];
    }
    
    if (indexPath.row == 0) {
        cell.groupTitleLabel.text = kLanguageForKey(331);
    }else if (indexPath.row == 1){
        cell.groupTitleLabel.text = kLanguageForKey(332);
    }else if (indexPath.row == 2){
        cell.groupTitleLabel.text = kLanguageForKey(401);
    }else if (indexPath.row == 3){
        cell.groupTitleLabel.text = kLanguageForKey(402);
    }
    
    cell.delayTimeTitleLabel.text =  kLanguageForKey(57);
    cell.blowTimeTitleLabel.text =  kLanguageForKey(58);
    cell.ejectTypeTitleLabel.text =  kLanguageForKey(59);
    cell.centerPointTitleLabel.text =  kLanguageForKey(60);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delayTimeTextField.text = [NSString stringWithFormat:@"%d",device->groupDelayTime[indexPath.row]];
    cell.blowTimeTextField.text = [NSString stringWithFormat:@"%d",device->groupBlowTime[indexPath.row]];
    cell.ejectTypeSegmentedControl.selectedSegmentIndex = device->groupEjectorType[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (device->groupUseCenterPoint[indexPath.row]) {
        [cell.centerPointSwitch setOn:true];
    }
    else
        [cell.centerPointSwitch setOn:false];
    
    NSArray *workModeArray = @[kLanguageForKey(51),kLanguageForKey(52),kLanguageForKey(53),kLanguageForKey(54)];
    cell.valveWorkModeComboBox.entries = workModeArray;
    cell.valveWorkModeComboBox.tableViewOnAbove = YES;
    [cell.valveWorkModeComboBox setFont:[UIFont systemFontOfSize:13.0f]];
    cell.valveWorkModeTitleLabel.text =  kLanguageForKey(55);
    cell.valveWorkModeTitleLabel.font = SYSTEMFONT_14f;
    cell.valveWorkModeTitleLabel.textColor = [UIColor TaiheColor];
    cell.valveWorkModeComboBox.selectedItem =device->groupValveWorkMode[indexPath.row];
    
    cell.valveOpenTimeLabel.text =  kLanguageForKey(56);
    cell.valveOpenTimeLabel.font = SYSTEMFONT_14f;
    cell.valveOpenTimeLabel.textColor = [UIColor TaiheColor];
    cell.valveOpenTimeTextField.text = [NSString stringWithFormat:@"%d",device->groupOpenValveTime[indexPath.row]];
    return cell;
}

#pragma tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    Byte data[4]= {0};
    data[0]=device.currentLayerIndex;
    data[1]= row;
    data[2]= index;
    data[3] = value;
    [[NetworkFactory sharedNetWork] setGroupValveParaWithData:data];
    
}

#pragma mark 切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork]getGroupValvePara];
}

@end
