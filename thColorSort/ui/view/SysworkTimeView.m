//
//  SysworkTimeView.m
//  thColorSort
//
//  Created by huanghu on 2018/1/15.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "SysworkTimeView.h"
@interface SysworkTimeView ()
@property (strong, nonatomic) IBOutlet UILabel *machineTotalWorkTimeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *machineOpenTimeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *machineOpenTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *machineTotalWorkTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *machineCurrentWorkTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *machineCurrentWorkTimeTitleLabel;

@end
@implementation SysworkTimeView
-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"SysworkTimeView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [[NetworkFactory sharedNetWork] getSysWorkTimeInfo];
    self.title = kLanguageForKey(305);
    self.machineOpenTimeTitleLabel.text = kLanguageForKey(310);
    self.machineTotalWorkTimeTitleLabel.text =[NSString stringWithFormat:@"%@(%@)", kLanguageForKey(308),kLanguageForKey(309)];
    self.machineCurrentWorkTimeTitleLabel.text = [NSString stringWithFormat:@"%@(%@)", kLanguageForKey(307),kLanguageForKey(309)];
    return self;
}


-(void)updateWithHeader:(NSData *)headerData{
    unsigned const char*header = headerData.bytes;
    if (header[0] == 0xa0) {
        Device *device = kDataModel.currentDevice;
        
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }
}

@end
