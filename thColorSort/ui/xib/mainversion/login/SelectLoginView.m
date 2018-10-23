//
//  SelectLoginView.m
//  thColorSort
//
//  Created by huanghu on 2018/10/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SelectLoginView.h"
#import <QuartzCore/QuartzCore.h>
#import "FileDownLoader.h"
#import "FileOperation.h"
#import "TipsView.h"
@interface SelectLoginView()
@property (strong, nonatomic) IBOutlet UIButton *localLogin;
@property (strong, nonatomic) IBOutlet UIButton *remoteLogin;

@property (strong, nonatomic) IBOutlet UIButton *languagebtn;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end
@implementation SelectLoginView

-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SelectLoginView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    
    return self;
}


-(UIView*) getViewWithPara:(NSDictionary *)para{
    [self initLanguage];
    self.localLogin.layer.cornerRadius = 4.0f;
    self.remoteLogin.layer.cornerRadius = 4.0f;
    [self.localLogin setBackgroundColor:[UIColor TaiheColor]];
    [self.remoteLogin setBackgroundColor:[UIColor TaiheColor]];
    [self.languagebtn setTitleColor:[UIColor TaiheColor] forState:UIControlStateNormal];
    //1先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    NSString *versionTitle = [NSString stringWithFormat:@"V %@",currentVersion];
    self.versionLabel.text = versionTitle;
    [[FileDownLoader sharedDownloader] downloadFileWithType:1 FileName:@"config.json"];
    return self;
}
- (IBAction)remoteLoginClicked:(id)sender {
    [self.paraNextView setObject:kLanguageForKey(232) forKey:@"title"];
    [gMiddeUiManager ChangeViewWithName:@"LoginUI" Para:self.paraNextView];
}


@end
