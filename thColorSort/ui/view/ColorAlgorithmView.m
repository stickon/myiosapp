//
//  ColorAlgorithmView.m
//  ThColorSortNew
//
//  Created by huanghu on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "ColorAlgorithmView.h"
#import "TableViewCellRebuild.h"
#import "MyGroupView.h"
#import "ColorAlgViewModel.h"
#import "CBTableViewDataSource.h"
@interface ColorAlgorithmView()<GroupBtnDelegate>

@property (nonatomic,strong) NSIndexPath* selectIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MyGroupView *groupBtnsView;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) ColorAlgViewModel *model;
@end
@implementation ColorAlgorithmView


-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"ColorAlgorithmView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
//        self.tableView.mj_header = self.refreshHeader;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.groupBtnsView.delegate = self;
        Device *device = kDataModel.currentDevice;
        if (device->machineData.layerNumber>1) {
            self.baseLayerLabel = self.currentLayerLabel;
        }else{
            self.currentLayerLabel.frame = CGRectZero;
            self.currentLayerLabelHeightConstraint.constant = 0.0f;
        }
        [self initView];
    }
    
    return self;
}
- (ColorAlgViewModel *)model {
    if(!_model) {
        _model = [[ColorAlgViewModel alloc]init];
    }
    return _model;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self refreshCurrentView];
    return self;
}

-(void)initView{
    [super initView];
    __weak typeof(self) weakSelf = self;
    self.model.dataUpdate = ^{
        [weakSelf.tableView reloadData];
    };
    [_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
        
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.headerTitle(kLanguageForKey(75));
            section.cell([TableViewCellRebuild class])
            .data(self.model.FrontDataArray)
            .adapter(^(TableViewCellRebuild * cell,NSDictionary * data,NSUInteger index){
                [cell.itemName setText:data[@"algName"]];
                NSNumber *use = data[@"useState"];
                if (use.intValue == 1) {
                    cell.useBtn.selected = YES;
                }else{
                    cell.useBtn.selected = NO;
                }
                
                NSNumber *sense = data[@"senseValue"];
                [cell.itemSenseTextField setText:[NSString stringWithFormat:@"%d",sense.intValue]];
                NSNumber *max = data[@"senseMax"];
                NSNumber *min = data[@"senseMin"];
                [cell setTextFieldMin:min.integerValue Max:max.integerValue];
                cell.delegate = weakSelf;
                cell.indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            })
            .event(^(NSUInteger index,NSDictionary * data){
        
            })
            .autoHeight;
        }];
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.headerTitle(kLanguageForKey(76));
            section.cell([TableViewCellRebuild class])
            .data(self.model.RearDataArray)
            .adapter(^(TableViewCellRebuild * cell,NSDictionary * data,NSUInteger index){
                [cell.itemName setText:data[@"algName"]];
                NSNumber *use = data[@"useState"];
                if (use.intValue == 1) {
                    cell.useBtn.selected = YES;
                }else{
                    cell.useBtn.selected = NO;
                }
                
                NSNumber *sense = data[@"senseValue"];
                [cell.itemSenseTextField setText:[NSString stringWithFormat:@"%d",sense.intValue]];
                NSNumber *max = data[@"senseMax"];
                NSNumber *min = data[@"senseMin"];
                [cell setTextFieldMin:min.integerValue Max:max.integerValue];
                cell.delegate = weakSelf;
                cell.indexPath = [NSIndexPath indexPathForRow:index inSection:1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            })
            .event(^(NSUInteger index,id row){
            })
            .autoHeight;
        }];
    }];
    [self updateGroupBtnHidden];
}
-(void)updateGroupBtnHidden{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
    }else{
        if (device->machineData.groupNum<=1) {
            self.groupBtnsView.hidden = YES;
        }else{
            NSArray *arr = [NSArray array];
            for (int i = 0; i < device->machineData.groupNum; i++) {
                arr = [arr arrayByAddingObject:[NSString stringWithFormat:@"%@ %d",kLanguageForKey(372),i+1]];
            }
            if (self.groupBtnsView->groupNum != device->machineData.groupNum) {
                [self.groupBtnsView setGroupNum:device->machineData.groupNum Title:arr SelectedIndex:0];
            }
            
            self.groupBtnsView.hidden = NO;
            
        }
    }
}

-(void)refreshCurrentView{
    Device *device = kDataModel.currentDevice;
    [gNetwork getAllAlgInfoWithGroup:device.currentGroupIndex Type:0];
}

-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* a = headerData.bytes;
    if (a[0] == 0x07) {
        if (a[1] == 0x01) {
            [self.model fetchData:headerData];
        }else if (a[1] == 0x02){
            [self refreshCurrentView];
        }else if (a[1] == 0x03){
            [self refreshCurrentView];
        }
        
    }
    else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [self refreshCurrentView];
    }
}
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value{
    Device *device = kDataModel.currentDevice;
    
    Byte groupIndex = device.currentLayerIndex;
    NSDictionary *dic = [[self.model.DataArray objectAtIndex:section] objectAtIndex:row];
    NSNumber *type = dic[@"type"];
    NSNumber *subType = dic[@"subType"];
    NSNumber *extType = dic[@"extType"];
    if (index == 0) {
        [gNetwork setAlgSenseValueWithGroup:groupIndex View:section Type:type.intValue SubType:subType.intValue ExtType:extType.intValue Used:value];
    }else{
        [gNetwork setAlgSenseValueWithGroup:groupIndex View:section Type:type.intValue SubType:subType.intValue ExtType:extType.intValue Value:value];
    }
}

- (void)groupBtnClicked:(Byte)index{
    Device *device = kDataModel.currentDevice;
    device.currentGroupIndex = index;
    [self refreshCurrentView];
}
#pragma changeViewDelegate
- (void)selectLayer:(NSUInteger)layer View:(NSUInteger)view
{
    kDataModel.currentDevice.currentLayerIndex = layer;
    kDataModel.currentDevice.currentViewIndex = 0;
    [self refreshCurrentView];
}

@end
