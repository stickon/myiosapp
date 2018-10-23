//
//  ModeListView.m
//  thColorSort
//
//  Created by huanghu on 2018/1/11.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "ModeListView.h"
#import "TableViewCellWithDefaultLabel2Button.h"
#import "CBTableViewDataSource.h"
static NSString* modeCellIdentifier = @"TableViewCellWithDefaultLabel2Button";

@implementation ModeListModel
- (instancetype)init {
    if(self = [super init]){
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)fetchData:(NSData*)data{
    SocketHeader header;
    memcpy(&header, data.bytes, HeaderLength);
    if (header.type == 0x04) {
        if (header.extendType == 0x01) {
            [self.dataArray removeAllObjects];
            self.bigIndex = header.data1[0];
            self.smallIndex = [NSString stringWithFormat:@"%d",header.data1[1]];
            NSData *modeListData = [data subdataWithRange:NSMakeRange(HeaderLength, data.length-HeaderLength)];
            NSString *ModeListStr = [[NSString alloc]initWithData:modeListData encoding:NSUTF8StringEncoding];
                NSArray *modeListArray=[ModeListStr componentsSeparatedByString:@"$"];
            
            NSEnumerator *enumetor = [modeListArray objectEnumerator];
            NSString* obj = nil;
            while (obj = [enumetor nextObject]) {
                NSArray *modeArray = [obj componentsSeparatedByString:@"#"];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[modeArray objectAtIndex:0],@"modeName",[modeArray objectAtIndex:1],@"modeCreateTime",[modeArray objectAtIndex:2],@"modeIndex",nil];
                
                [self.dataArray addObject:dic];
            }
        }else if (header.extendType == 0x02){
            self.smallIndex = [NSString stringWithFormat:@"%d",header.data1[0]];
        }
    }
    if (self.dataUpdate) {
        self.dataUpdate();
    }
}

@end

@interface ModeListView()<TableViewCellChangedDelegate>
{
    bool dataLoaded;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *selectPath;
@property (strong,nonatomic) NSIndexPath *currentUsePath;
@property (strong,nonatomic) ModeListModel *model;
@end
@implementation ModeListView
-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ModeListView" owner:self options:nil] firstObject];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.bounces = NO;
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}
-(UIView *)getViewWithPara:(NSDictionary *)para{
    dataLoaded = false;
    [self refreshCurrentView];
    return self;
}
- (void)refreshCurrentView{
    Device *device = kDataModel.currentDevice;
    device.currentSelectBigModeIndex = device->machineData.sortModeBig;
    
     [[NetworkFactory sharedNetWork] getSmallModeNameListWithBigModeIndex:device->machineData.sortModeBig];
}
-(ModeListModel *)model{
    if (!_model) {
        _model = [[ModeListModel alloc] init];
    }
    return _model;
}

-(void)initView{
    [super initView];
    __weak typeof(self) weakSelf = self;
    self.model.dataUpdate = ^{
        [weakSelf.tableView reloadData];
    };
    [_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
        
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([TableViewCellWithDefaultLabel2Button class])
            .data(self.model.dataArray)
            .adapter(^(TableViewCellWithDefaultLabel2Button * cell,NSDictionary * data,NSUInteger index){
                [cell.title setText:data[@"modeName"]];
                [cell.detailTitle setText:data[@"modeCreateTime"]];
                cell.delegate = weakSelf;
                cell.indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                NSString *string = [NSString stringWithString:data[@"modeIndex"]];
                int mode = string.intValue;
                NSString *curIndex = [NSString stringWithString:self.model.smallIndex];
                int modeindex = curIndex.intValue;
                if (mode == modeindex) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            })
            .event(^(NSUInteger index,NSDictionary * data){
                NSString *smallIndex = data[@"modeIndex"];
                [gNetwork useModeWithIndex:smallIndex.intValue BigModeIndex:0];
            })
            .autoHeight;
        }];
    }];
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char*a = headerData.bytes;
    Device *device = kDataModel.currentDevice;
    if (a[0] == 0x04) {
        if (a[1] == 0x01 || a[1] == 0x02){
            [self.model fetchData:headerData];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork]getSmallModeNameListWithBigModeIndex:device->machineData.sortModeBig];
    }
}

-(BOOL)Back{
    [[NetworkFactory sharedNetWork] getCurrentDeviceInfo];
    return [super Back];
}

#pragma mark - tableviewcell delegate
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{
    
}
@end
