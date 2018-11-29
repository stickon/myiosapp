//
//  SvmView.m
//  thColorSort
//
//  Created by huanghu on 2018/1/17.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "SvmView.h"
#import "MyGroupView.h"
#import "SingleViewSvm.h"
@interface SvmView ()<GroupBtnDelegate>
@property (strong, nonatomic) IBOutlet MyGroupView *groupBtnsView;
@property (strong, nonatomic) IBOutlet SingleViewSvm *frontSvm;
@property (strong, nonatomic) IBOutlet SingleViewSvm *rearSvm;
@property (retain, nonatomic) NSArray *viewSvmArray;
@end
@implementation SvmView


-(instancetype)init{
    if (self = [super init]) {
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SvmView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self refreshCurrentView];
    self.frontSvm.hidden = YES;
    self.rearSvm.hidden = YES;
    return self;
}
-(void)refreshCurrentView{
    Device *device = kDataModel.currentDevice;
    [gNetwork getSvmInfoWithGroup:device.currentGroupIndex];
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char *a = headerData.bytes;
    if (a[0] == 0x08){
        if (a[1] == 1) {
            [self updateView:headerData];
        }else if (a[1] == 2){
            [self refreshCurrentView];
        }
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getSvmPara];
    }
}
- (void)initView{
    [self initLanguage];
    self.viewSvmArray = [NSArray arrayWithObjects:self.frontSvm,self.rearSvm, nil];
    [self updateGroupBtnHidden];
    self.groupBtnsView.delegate = self;
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
-(void)updateView:(NSData*)data{
    SocketHeader header;
    memcpy(&header, data.bytes, Socket_Header_Length);
    if (header.extendType == 0x01) {
        int svmcount = (int)(data.length-Socket_Header_Length)/sizeof(SvmInfo);
        for(int i = 0;i<svmcount;i++){
            SvmInfo tempSvm;
            memcpy(&tempSvm, data.bytes+Socket_Header_Length+i*sizeof(SvmInfo), sizeof(SvmInfo));
            [[self.viewSvmArray objectAtIndex:i] updateViewWithData:&tempSvm];
            [[self.viewSvmArray objectAtIndex:i] setHidden:NO];
        }
    }
}
-(void)initLanguage{
//    [self.frontViewBtn setTitle:kLanguageForKey(75) forState:UIControlStateNormal];
//    [self.rearViewBtn setTitle:kLanguageForKey(76) forState:UIControlStateNormal];
//    self.impurityTitleLabel.text = kLanguageForKey(184);
//    self.senseValueTitleLabel.text = kLanguageForKey(14);
//    [self.rejectBtn setTitle:kLanguageForKey(183) forState:UIControlStateNormal];
//    [self.rejectBtn setTitle:kLanguageForKey(182) forState:UIControlStateSelected];
//    [self.useBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
//    [self.useBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
//
}

#pragma mark GroupBtnDelegate
- (void)groupBtnClicked:(Byte)index{
    Device *device = kDataModel.currentDevice;
    device.currentGroupIndex = index;
    [self refreshCurrentView];
}

@end
