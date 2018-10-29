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
@property (strong, nonatomic) IBOutlet UILabel *FeedAllLabel;
@property (strong, nonatomic) IBOutlet UIButton *minusAllBtn;
@property (strong, nonatomic) IBOutlet UIButton *plusAllBtn;
@property (strong, nonatomic) IBOutlet BaseUITextField *FeedAllTextField;
@property (strong, nonatomic) IBOutlet UIView *FeedAllView;

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
        [self initLanguage];
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [self refreshCurrentView];
    [self setFeedAllViewVisible];
    return self;
}
- (void)refreshCurrentView{
    dataloaded = false;
    [[NetworkFactory sharedNetWork] getVibSettingValue];
}
-(void)initLanguage{
    self.FeedAllLabel.text = kLanguageForKey(333);
    
}
-(void)updateWithHeader:(NSData*)headerData
{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x05) {
        if (header[1] == 0x01) {
            [self.model fetchData:headerData];
            dataloaded = true;
            self.FeedAllTextField.text = [NSString stringWithFormat:@"%d",self.model->vib.groupData[0]];
            [self.tableView reloadData];
        }else if (header[1] == 0x02 || header[1] == 3){
            [self refreshCurrentView];
        }
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}
- (IBAction)feedTypeChanged:(UISegmentedControl *)sender {
    [self setFeedAllViewVisible];
    [self.tableView reloadData];
}
- (void)setFeedAllViewVisible{
    if (self.chuteTypeChange.selectedSegmentIndex == 0) {
        self.FeedAllView.hidden = YES;
    }else{
        self.FeedAllView.hidden = NO;
    }
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
    return 54;
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
        int index = indexPath.row+401;
        cell.feedCellTitle.text = kLanguageForKey(index);
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
    if (self.chuteTypeChange.selectedSegmentIndex == 0) {
        if (index == 1) {
            [gNetwork setVibValue:3 Index:row Value:value];
        }else if (index == 2){
            [gNetwork setVibState:3 Index:row State:value];
        }else if (index == 3){
            if (self.model->vib.groupData[row]>1) {
                [gNetwork setVibValue:3 Index:row Value:self.model->vib.groupData[row]-1];
            }
            
        }else if (index == 4){
            if (self.model->vib.groupData[row]<99) {
                [gNetwork setVibValue:3 Index:row Value:self.model->vib.groupData[row]++];
            }
        }
    }else{
        if (index == 1) {
            [gNetwork setVibValue:1 Index:row Value:value];
        }else if (index == 2){
            [gNetwork setVibState:1 Index:row State:value];
        }else if (index == 3){
            if (self.model->vib.vibdata[row] > 1) {
                [gNetwork setVibValue:0 Index:row Value:self.model->vib.vibdata[row]--];
            }
        }else if (index == 4){
            if (self.model->vib.vibdata[row]<99) {
                [gNetwork setVibValue:0 Index:row Value:self.model->vib.vibdata[row]++];
            }
        }
    }
}


-(void)cellBtnClicked:(long)section row:(long)row tag:(long)tag value:(NSInteger)value bSend:(BOOL)bsend{
    if (section == 0)
    {
        if (bsend) {
            if (self.chuteTypeChange.selectedSegmentIndex == 0) {
                self.model->vib.groupData[row] = value;
                [gNetwork setVibValue:3 Index:row Value:value];
            }else{
                self.model->vib.vibdata[row] = value;
                [gNetwork setVibValue:0 Index:row Value:value];
            }
        }
    }
}


-(void)reloadRows{
    NSArray *rowArray =[NSArray array];
    int rowCount = 0;
    if (self.chuteTypeChange.selectedSegmentIndex == 0) {
        rowCount = self.model->vib.group;
    }else
        rowCount = self.model->vib.ch;
    for (int i= 0; i<rowCount;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        rowArray  = [rowArray arrayByAddingObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)changeFeedbtnClicked:(UIButton *)sender {
    if (sender == self.minusAllBtn) {
        [gNetwork setVibValue:2 Index:0 Value:1];
    }else if (sender == self.plusAllBtn){
        [gNetwork setVibValue:1 Index:0 Value:1];
    }
}
@end
