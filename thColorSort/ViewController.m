//
//  ViewController.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "ViewController.h"
#import "TopManager.h"
#import "MiddleManager.h"
#import "BottomManager.h"
#import "VersionViewPageManager.h"
#import "InternationalControl.h"
#import "FileOperation.h"
#import "types.h"
@interface ViewController ()



@end

@implementation ViewController
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [FileOperation checkIsFirst];
    [InternationalControl initUserLanguage];
    // Do any additional setup after loading the view, typically from a nib.
    [_middleView setUserInteractionEnabled:YES];
    [self.topView setBackgroundColor:[UIColor TaiheColor]];
    [[TopManager shareInstance] attachView:_topView];
    
    [[MiddleManager shareInstance] attachView:_middleView];
    
    [[BottomManager shareInstance] attachView:_bottomView];
    
    
    [[MiddleManager shareInstance] attachObserver:[TopManager shareInstance]];
    
    [[MiddleManager shareInstance] attachObserver:[BottomManager shareInstance]];
    
    NSDictionary *dic = @{@"title":kLanguageForKey(5)};
    [[MiddleManager shareInstance] ChangeViewWithName:@"SelectLoginView" Para:dic];
    
    [self setStatusBarBackgroundColor:[UIColor TaiheColor]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)click:(id)sender {
    NSLog(@"........");
}
@end
