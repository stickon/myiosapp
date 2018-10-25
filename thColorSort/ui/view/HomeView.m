//
//  HomeView.m
//  ThColorSortNew
//
//  Created by huanghu on 2017/12/19.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "HomeView.h"
#import "DataModel.h"
#import "BaseUITextField.h"
#import "TableViewCellWithDefaultTitleLabel1Switch.h"
#import "TableViewCellWithDefaultTitleLabel1TextField.h"
#import "TableViewCellWith1button.h"
static NSString* switchCellName = @"TableViewCellWithDefaultTitleLabel1Switch";
static NSString* valveCellIdentifier = @"valveCellIdentifier";
static NSString* commonCellIdentifier = @"commonCellIdentifier";
static NSString* feedSettingCellIdentifier = @"TableViewCellWithDefaultTitleLabel1TextField";
static NSString* buttonCellIdentifier = @"TableViewCellWith1button";
@interface HomeView()<UITableViewDataSource,UITableViewDelegate,TableViewCellChangedDelegate>
{
    BOOL bChangeState;
    Byte feedState;
    Byte valveState;
    Byte vibInState;
    Byte vibOutState;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
@implementation HomeView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"HomeView" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        bChangeState = false;
        [self.tableView registerNib:[UINib nibWithNibName:switchCellName bundle:nil] forCellReuseIdentifier:valveCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:switchCellName bundle:nil] forCellReuseIdentifier:commonCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:feedSettingCellIdentifier bundle:nil] forCellReuseIdentifier:feedSettingCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:buttonCellIdentifier bundle:nil] forCellReuseIdentifier:buttonCellIdentifier];
        self.tableView.delegate = self;
        self.tableView.dataSource =self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.bounces = NO;
        self.tableView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.3];
        
        Device *device = kDataModel.currentDevice;
        if (device->screenProtocolMainVersion > kDataModel.protocolMainVersion) {
            [self makeToast:kLanguageForKey(366) duration:3.0 position:CSToastPositionCenter];
        }
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [self refreshCurrentView];
    return self;
}
- (void)refreshCurrentView{
    [[NetworkFactory sharedNetWork] getCurrentDeviceInfo];
    [gNetwork getSysWorkTimeInfo];
}
-(void)updateWithHeader:(NSData*)headerData
{
    const unsigned char *a = headerData.bytes;
    if (a[0] == 3 || a[0] == 8 || a[0] == 0x0f || (a[0] == 0xa1 && a[1] == 1)||a[0] == 1) {
        [self.tableView reloadData];
        if ((a[1] == 3 && a[2] != 2) || (a[1] == 4 && a[2] == 0)) {
            [self refreshCurrentView];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [self refreshCurrentView];
    }else if (a[0] == 0x0d){
        if (a[1] == 6) {
            if (a[2] == 1) {
                [self makeToast:kLanguageForKey(205) duration:2.0 position:CSToastPositionCenter];
            }else{
                [self makeToast:kLanguageForKey(206) duration:2.0 position:CSToastPositionCenter];
            }
        }else{
            [self.tableView reloadData];
        }
    }else if (a[0] == 0x12){
        Device *device = kDataModel.currentDevice;
        if (a[1] == 1) {
                NSUInteger totalWorkTime = device->workTime.totalTime[0] *256*256*256+device->workTime.totalTime[1]*256*256+device->workTime.totalTime[2]*256+device->workTime.totalTime[3];
                NSString *totalWorkstr= [NSString stringWithFormat:@"%lu",(unsigned long)totalWorkTime];
                NSString *totalWorkTitle =[NSString stringWithFormat:@"%@(%@)", kLanguageForKey(308),kLanguageForKey(309)];
            NSString *currentWorkTitle = [NSString stringWithFormat:@"%@(%@)", kLanguageForKey(307),kLanguageForKey(309)];
                NSUInteger currentWorkTime = device->workTime.todayTime[0] *256*256*256+device->workTime.todayTime[1]*256*256+device->workTime.todayTime[2]*256+device->workTime.todayTime[3];
                NSString *todayWorkstr= [NSString stringWithFormat:@"%lu",(unsigned long)currentWorkTime];
            self.textView.text = [NSString stringWithFormat:@"%@:%@",totalWorkTitle,totalWorkstr];
         
        }
    }
}
#pragma mark tableview datasource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    Device *device = kDataModel.currentDevice;
    if (device) {
        return 4;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Device *device = kDataModel.currentDevice;
    if (device) {
        if (section == 0) {
            return 2;
        }
        if (section == 1) {
            return 2;
        }
        if (section == 2) {
            return 2;
        }
        if (section == 3) {
            return 1;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (device) {
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                    return 0;
            }else if (indexPath.row == 4){
                    return 0;
            }
            else if (indexPath.row == 5){
                if (device->machineData.machineType != MACHINE_TYPE_WHEEL&& device->machineData.machineType != MACHINE_TYPE_WHEEL_2) {
                    return 0;
                }
            }else if (indexPath.row == 6){
                if (device->machineData.machineType != MACHINE_TYPE_WHEEL_2) {
                    return 0;
                }
            }
        }
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (device) {
        Byte tempfeedState = device->machineData.feederState;
        Byte tempvalveState = device->machineData.valveState;
        Byte tempcleanState = device->machineData.cleanState;
        Byte tempstartState = device->machineData.startState;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                TableViewCellWithDefaultTitleLabel1Switch *tableCell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier forIndexPath:indexPath];
                
                tableCell.accessoryType = UITableViewCellAccessoryNone;
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableCell.textLabel.text = kLanguageForKey(19) ;
                tableCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableCell.textLabel.textColor = [UIColor TaiheColor];
                if (tempfeedState) {
                    [tableCell.switchBtn setOn:true];
                }else{
                    [tableCell.switchBtn setOn:false];
                }
                tableCell.switchBtn.tag = 101;
                tableCell.delegate = self;
                tableCell.indexPath = indexPath;
                return tableCell;
            }else if(indexPath.row == 1){
                TableViewCellWithDefaultTitleLabel1Switch *tableCell = [tableView dequeueReusableCellWithIdentifier:valveCellIdentifier forIndexPath:indexPath];
#ifdef Engineer
                tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#else
#endif
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                tableCell.textLabel.font = [UIFont systemFontOfSize:14.0];
                tableCell.textLabel.textColor = [UIColor TaiheColor];
                if (tempvalveState) {
                    tableCell.textLabel.text = kLanguageForKey(1006);
                    [tableCell.switchBtn setOn:true];
                }else{
                    tableCell.textLabel.text = kLanguageForKey(1007);
                    [tableCell.switchBtn setOn:false];
                }
                tableCell.switchBtn.tag = 102;
                tableCell.delegate = self;
                tableCell.indexPath = indexPath;
                return tableCell;
            }
            
        }
        else if (indexPath.section == 1){
            TableViewCellWith1button *tableViewCell = [tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier forIndexPath:indexPath];
            tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell.button.tag = 202;
            tableViewCell.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            tableViewCell.delegate =self;
            tableViewCell.indexPath = indexPath;
            if (indexPath.row == 0) {
                if (tempcleanState == 0) {
                    [tableViewCell.button setTitle:kLanguageForKey(22)  forState:UIControlStateNormal];
                    tableViewCell.button.backgroundColor = [UIColor TaiheColor];
                    tableViewCell.button.userInteractionEnabled = YES;
                }else{
                    [tableViewCell.button setTitle:kLanguageForKey(24)  forState:UIControlStateNormal];
                    tableViewCell.button.backgroundColor = [UIColor greenColor];
                    [tableViewCell.button setUserInteractionEnabled:NO];
                }
                tableViewCell.accessoryType = UITableViewCellAccessoryNone;
            }else if (indexPath.row == 1){
                tableViewCell.accessoryType = UITableViewCellAccessoryNone;
                tableViewCell.button.tag = 201;
                switch (tempstartState) {
                    case 0:
                        [tableViewCell.button setTitle:kLanguageForKey(26)  forState:UIControlStateNormal];
                        [tableViewCell.button setUserInteractionEnabled:YES];
                        [tableViewCell.button setBackgroundColor:[UIColor TaiheColor]];
                        break;
                    case 1:
                        [tableViewCell.button setTitle:kLanguageForKey(25)  forState:UIControlStateNormal];
                        [tableViewCell.button setUserInteractionEnabled:YES];
                        [tableViewCell.button setBackgroundColor:[UIColor greenColor]];
                        break;
                    case 2:
                        [tableViewCell.button setTitle:kLanguageForKey(27)  forState:UIControlStateNormal];
                        [tableViewCell.button setUserInteractionEnabled:NO];
                        [tableViewCell.button setBackgroundColor:[UIColor greenColor]];
                        break;
                    case 3:
                    {
                        [tableViewCell.button setUserInteractionEnabled:YES];
                        [tableViewCell.button setBackgroundColor:[UIColor TaiheColor]];
                        [tableViewCell.button setTitle:kLanguageForKey(26)  forState:UIControlStateNormal];
                    }
                        break;
                    default:
                        break;
                }
            }
            return tableViewCell;
            
        }
    }
    static NSString* defaultCell = @"DefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    if(cell== nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defaultCell ];
    }
    if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = kLanguageForKey(336) ;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.textColor = [UIColor TaiheColor];
            NSString *modeNameStr = [NSString stringWithFormat:@"%@ [%d-%d]",device.modeName,device->machineData.sortModeBig+1,device->machineData.sortModeSmall];
            cell.detailTextLabel.text = modeNameStr;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.tableView.rowHeight);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 1){
            TableViewCellWith1button *tableViewCell = [tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier forIndexPath:indexPath];
            tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell.button.tag = 204;
            tableViewCell.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            tableViewCell.delegate =self;
            tableViewCell.indexPath = indexPath;
            [tableViewCell.button setTitle:kLanguageForKey(138)  forState:UIControlStateNormal];
            [tableViewCell.button setBackgroundColor:[UIColor TaiheColor]];
            return tableViewCell;
        }
    }
    else if (indexPath.section == 3){
        TableViewCellWith1button *tableViewCell = [tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier forIndexPath:indexPath];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableViewCell.button.tag = 203;
        tableViewCell.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        tableViewCell.delegate =self;
        tableViewCell.indexPath = indexPath;
        [tableViewCell.button setTitle:kLanguageForKey(1001)  forState:UIControlStateNormal];
        [tableViewCell.button setBackgroundColor:[UIColor redColor]];
        return tableViewCell;
    }
    return cell;
}
#pragma mark tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.paraNextView setObject:kLanguageForKey(23) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"FeedSetView" Para:self.paraNextView];
        }
#ifdef Engineer
        if (indexPath.row == 1) {
            [self.paraNextView setObject:kLanguageForKey(18) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"ValveSetView" Para:self.paraNextView];
        }
#else
#endif
    }
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self.paraNextView setObject:kLanguageForKey(21) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"CleanSetView" Para:self.paraNextView];
        }
    }
    Device *device = kDataModel.currentDevice;
    if (device) {
        if (indexPath.section == 2) {
            [self.paraNextView setObject:kLanguageForKey(90) forKey:@"title"];
            [gMiddeUiManager ChangeViewWithName:@"ModeListView" Para:self.paraNextView];
        }
    }
}

#pragma mark tableviewcell delegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{
    if (index == 203) {
        [self disconnectDevice];
    }else if(index == 204){
        [[NetworkFactory sharedNetWork] saveCurrentMode];
    }
    else{
        bChangeState = true;
        [self setDeviceRunState:index Value:value];
    }
}

-(void)disconnectDevice
{
    [[NetworkFactory sharedNetWork] disconnnectCurrentDevice];
    [super logOut];
}
- (void)setDeviceRunState:(NSInteger)tag Value:(Byte)value
{
    bChangeState = true;
    Byte type = 0;
    if (tag<203) {
        switch (tag) {
            case 101:
                type = 1;
                feedState = value;
                break;
            case 102:
                type = 2;
                valveState = value;
                break;
            case 201://start
                
                type = 3;
                break;
            case 202://clean
                type = 4;
                break;
            default:
                break;
        }
        [[NetworkFactory sharedNetWork]setDeviceRunState:value withType:type];
    }else if(tag<1000)
    {
        if (tag == 801) {
            type = 1;
            [[NetworkFactory sharedNetWork] setVibInOutSwitchStateWithType:type];
        }else if (tag == 802){
            type = 2;
            [[NetworkFactory sharedNetWork] setVibInOutSwitchStateWithType:type];
        }else if (tag == 804){
            type = 4;
        }
        
        
        
    }else{
        if (tag == 1000) {
            [[NetworkFactory sharedNetWork] switchCaterpillar:value withLayerIndex:1];
        }else if (tag == 1001){
            [[NetworkFactory sharedNetWork] switchCaterpillar:value withLayerIndex:2];
        }
    }
}

-(void)dealloc{
    NSLog(@"home view dealloc");
}
@end
