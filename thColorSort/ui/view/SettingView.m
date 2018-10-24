//
//  SettingView.m
//  ThColorSortNew
//
//  Created by huanghu on 2017/12/19.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "SettingView.h"
@interface SettingView()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation SettingView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SettingView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(void)initView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
}
-(void)updateWithHeader:(NSData*)headerData
{
    const unsigned char* a = headerData.bytes;
    if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}

#pragma mark tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Device *device = kDataModel.currentDevice;
    if (device) {
        if (indexPath.row == 2 || indexPath.row == 3) {
            if (device->machineData.useLevel == 0) {
                return 0;
            }
            return 50;
        }
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *device = kDataModel.currentDevice;
    NSString *defaultTableViewCell = @"defaultcell";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
//        cell.imageView.image = [UIImage imageNamed:@"icon_version"];
        cell.textLabel.text = kLanguageForKey(77) ;
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
//        cell.imageView.image = [UIImage imageNamed:@"icon_valve"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(149) ;
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        return cell;
    }
    if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
//        cell.imageView.image = [UIImage imageNamed:@"icon_signal"];
        cell.textLabel.text = kLanguageForKey(96);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (device->machineData.useLevel == 0) {
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }else{
            cell.hidden = NO;
        }
        return cell;
    }
    if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
//        cell.imageView.image = [UIImage imageNamed:@"icon_light_adjust"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(196);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.useLevel == 0) {
            cell.hidden = YES;
            cell.frame = CGRectZero;
        }else{
            cell.hidden = NO;
        }
        return cell;
    }
    if (indexPath.row == 4){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultTableViewCell];
//        cell.imageView.image = [UIImage imageNamed:@"appLogs"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLanguageForKey(1012);
        cell.textLabel.font = SYSTEMFONT_15f;
        cell.textLabel.textColor = [UIColor TaiheColor];
        if (device->machineData.useLevel == 0) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
        return cell;
    }
    UITableViewCell *defaultCell = [[UITableViewCell alloc]init];
    return defaultCell;
}

#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.paraNextView setObject:kLanguageForKey(77) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"SoftwareVersionView" Para:self.paraNextView];
    }else if (indexPath.row == 1){
        [self.paraNextView setObject:kLanguageForKey(149) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"ValveShowInfoView" Para:self.paraNextView];
    }else if (indexPath.row == 2) {
        [self.paraNextView setObject:kLanguageForKey(96) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"SignalSettingView" Para:self.paraNextView];
    }else if (indexPath.row == 3){
        [self.paraNextView setObject:kLanguageForKey(174) forKey:@"title"];
        [gMiddeUiManager ChangeViewWithName:@"CalibrationView" Para:self.paraNextView];
    }
}

-(void)dealloc{
    NSLog(@"setting view dealloc");
}

@end
