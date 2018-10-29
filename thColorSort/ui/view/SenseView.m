//
//  SenseView.m
//  ThColorSortNew
//
//  Created by huanghu on 2017/12/19.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "SenseView.h"
@interface SenseView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSIndexPath* selectIndexPath;
@end
@implementation SenseView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SenseView" owner:self options:nil] firstObject];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.bounces = NO;
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    
    return self;
}
-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self refreshCurrentView];
    [self initLanguage];
    return self;
}
-(void)initLanguage{
    [super initLanguage];
}
-(void)refreshCurrentView{
    [self.tableView reloadData];
}
-(void)updateWithHeader:(NSData*)headerData
{
    const char* a = headerData.bytes;
    if (a[0] == 0x04 && a[1] == 0x01) {
        [self refreshCurrentView];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}

#pragma tableview data source

- (NSInteger)numberOfSectionsInTableVeiw:(UITableView*)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (device) {
        
        if (indexPath.row == 0) {
            if (device->machineData.useColor==0) {
                return 0;
            }
        }
        if (indexPath.row == 1) {
            if (device->machineData.useIR == 0) {
                return 0;
            }
        }
        if (indexPath.row == 2) {
            if (device->machineData.useShape<1) {
                return 0;
            }
        }
        if (indexPath.row == 3) {
            if (device->machineData.useSvm== 0) {
                return 0;
            }
        }
    
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    NSString *defaultTableViewCell = @"defaultcell";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.textLabel.text = kLanguageForKey(29);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (device->machineData.useColor) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        return cell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(104);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.useIR>0) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        return cell;
    }
    if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(30);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.useShape) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        return cell;
    }
    if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(31);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.useSvm) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }
        return cell;
        
    }
    if (indexPath.row == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(338);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
    
        return cell;
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}
#pragma mark - tableviewdelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.paraNextView setObject:kLanguageForKey(29) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"ColorAlgorithmView" Para:self.paraNextView];
    }
    if (indexPath.row == 1) {
        [self.paraNextView setObject:kLanguageForKey(176) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"IRAlgorithmView" Para:self.paraNextView];
    }
    if (indexPath.row == 2) {
        
    }
    if (indexPath.row == 3) {
        [self.paraNextView setObject:kLanguageForKey(31) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"SvmView" Para:self.paraNextView];
    }
    
    if (indexPath.row == 4) {
        [self.paraNextView setObject:kLanguageForKey(338) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"HsvView" Para:self.paraNextView];
    }
}


-(void)dealloc{
    NSLog(@"sense view dealloc");
}
@end
