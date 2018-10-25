//
//  FeedSetView.m
//  thColorSort
//
//  Created by huanghu on 2018/1/9.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "FeedSetView.h"
#import "FeedSettingTitleTableViewCell.h"
#import "FeedSettingTableViewCell.h"
#import "TableViewCellWith2Button.h"
@implementation FeedSetModel

-(void)fetchData:(NSData*)data{
    SocketHeader header;
    memcpy(&header, data.bytes, HeaderLength);
    if (header.type == 0x05) {
        if (header.extendType == 0x01) {
            memcpy(&vib, data.bytes+HeaderLength, sizeof(vib));
        }
    }
}
@end


static NSString *FeedCellIdentifier = @"FeedSettingTableViewCell";
static NSString *TotalAddDelCellIdentifier = @"TableViewCellWith2Button";
static NSString *FeedCellTitleIdentifier = @"FeedSettingTitleTableViewCell";
@interface FeedSetView()<UITableViewDelegate,UITableViewDataSource,TableViewCellChangedDelegate>
{
    BOOL dataloaded;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *chuteTypeChange;//分组或者分料槽
@property (strong, nonatomic) FeedSetModel *model;

@end
@implementation FeedSetView
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"FeedSet" owner:self options:nil] firstObject];
        
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
        [self.tableView registerNib:[UINib nibWithNibName:FeedCellTitleIdentifier bundle:nil] forCellReuseIdentifier:FeedCellTitleIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:FeedCellIdentifier bundle:nil] forCellReuseIdentifier:FeedCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:TotalAddDelCellIdentifier bundle:nil] forCellReuseIdentifier:TotalAddDelCellIdentifier];
        
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.model = [[FeedSetModel alloc] init];
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [self refreshCurrentView];
    return self;
}
- (void)refreshCurrentView{
    dataloaded = false;
    [[NetworkFactory sharedNetWork] getVibSettingValue];
}
-(void)updateWithHeader:(NSData*)headerData
{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x05) {
        if (header[1] == 0x01) {
            [self.model fetchData:headerData];
            dataloaded = true;
            [self.tableView reloadData];
        }else if (header[1] == 0x02){
            [self refreshCurrentView];
        }
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}
- (IBAction)feedTypeChanged:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

#pragma tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataloaded) {
        Device *device = kDataModel.currentDevice;
        if (device) {
            return 1;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataloaded) {
        if (self.chuteTypeChange.selectedSegmentIndex == 0) {
            return self.model->vib.group;
        }else
            return self.model->vib.ch;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.minusBtn.tag = 3;
    cell.plusBtn.tag = 4;
    if (self.chuteTypeChange.selectedSegmentIndex == 0) {
        cell.feedCellTitle.text = kLanguageForKey(400+indexPath.row);
        cell.feedNumTextField.text = [NSString stringWithFormat:@"%d",self.model->vib.groupData[indexPath.row]];
        if (self.model->vib.groupOpen[indexPath.row]) {
            cell.feedSwitch.on = YES;
        }else{
            cell.feedSwitch.on = NO;
        }
    }else{
        cell.feedCellTitle.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        cell.feedNumTextField.text = [NSString stringWithFormat:@"%d",self.model->vib.vibdata[indexPath.row]];
        if (self.model->vib.vibOpen[indexPath.row]) {
            cell.feedSwitch.on = YES;
        }else{
            cell.feedSwitch.on = NO;
        }
    }
    
    return cell;
}

#pragma table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma tableview cell delegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value
{
    Device *device = kDataModel.currentDevice;
    if (section == 0) {
        if (row > 0 && row <= device->vibSet.ch) {
            if (index == 1) {
                [[NetworkFactory sharedNetWork] setDeviceFeedInOutState:value withType:row-1 addOrDel:0 IsAll:0];
            }else if (index == 2){
                [[NetworkFactory sharedNetWork] setVibNum:row-1 Switch:value];
            }
        }else if (row == device->vibSet.ch+1){
            [[NetworkFactory sharedNetWork] setDeviceFeedInOutState:1 withType:0 addOrDel:index IsAll:1];
        }
    }
    if (section == 1) {
        if (index == 1) {//改变入料出料量
            [[NetworkFactory sharedNetWork] setVibInOut:row+1 Value:value];
        }else if (index == 2){//入料出料开关
            [[NetworkFactory sharedNetWork] setVibInOutSwitchStateWithType:row+1];
        }
    }
}


-(void)cellBtnClicked:(long)section row:(long)row tag:(long)tag value:(NSInteger)value bSend:(BOOL)bsend{
    Device *device = kDataModel.currentDevice;
    if (section == 0)
    {
        if (row == device->vibSet.ch+1) {
            if (bsend) {
                [[NetworkFactory sharedNetWork] setDeviceFeedInOutState:value withType:0 addOrDel:tag IsAll:1];
            }else{
                if (tag == 1) {
                    for (int i = 0; i<device->vibSet.ch; i++) {
                        if (device->vibdata[i]<99) {
                            device->vibdata[i]+=1;
                        }
                    }
                }else if (tag == 2){
                    for (int i = 0; i<device->vibSet.ch; i++) {
                        if (device->vibdata[i]>2) {
                            device->vibdata[i]-=1;
                        }
                    }
                }
                
                [self reloadRows];
            }
        }
    }
}


-(void)reloadRows{
    Device *device = kDataModel.currentDevice;
    NSArray *rowArray =[NSArray array];
    for (int i= 1; i<=device->vibSet.ch;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        rowArray  = [rowArray arrayByAddingObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationNone];
}
@end
