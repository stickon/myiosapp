//
//  FeedSettingTableViewCell.m
//  thColorSort
//
//  Created by huanghu on 2017/6/26.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "FeedSettingTableViewCell.h"
@interface FeedSettingTableViewCell(){
    NSTimer *timer;
}
@end
@implementation FeedSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.hidden = YES;
    self.feedNumTextField.tag = 1;
    self.feedSwitch.tag = 2;
    self.feedSwitch.onTintColor = [UIColor TaiheColor];
    self.minusBtn.tag = 3;
    self.plusBtn.tag = 4;
    
    UILongPressGestureRecognizer *longPressGR=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    UILongPressGestureRecognizer *longPressGR2=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [self.minusBtn addGestureRecognizer:longPressGR];
    [self.plusBtn addGestureRecognizer:longPressGR2];
}

static int valueTmp=0;
-(void)longPress:(UILongPressGestureRecognizer *)longPressGR{
    
    UIButton *btn=(UIButton *)longPressGR.view;
    
    if(longPressGR.state==UIGestureRecognizerStateBegan){
        btn.selected=YES;
        valueTmp=0;
        __weak typeof(self) weakself = self;
         timer=[NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
             if (btn.tag == 3) {
                 if (weakself.feedNumTextField.text.integerValue>1) {
                     weakself.feedNumTextField.text = [NSString stringWithFormat:@"%d",weakself.feedNumTextField.text.intValue-1];
                 }
             }else if (btn.tag  == 4){
                 if (weakself.feedNumTextField.text.integerValue < 99) {
                     weakself.feedNumTextField.text = [NSString stringWithFormat:@"%d",weakself.feedNumTextField.text.intValue+1];
                 }
             }
        }];
    }else{
        NSLog(@"longPress:%@",longPressGR);
        
        if (longPressGR.state == UIGestureRecognizerStateChanged) {
            return;
        }
        
        if(timer!=nil){
            btn.selected=NO;
            [timer invalidate];
            timer=nil;
            [super cellEditValueChangedWithTag:longPressGR.view.tag AndValue:self.feedNumTextField.text.integerValue bSend:true];
            NSLog(@"result %d",valueTmp);
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)feedSwitchValueChanged:(UISwitch *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.isOn];
}

- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:99 Min:1 Value:sender.text.integerValue];
}
- (IBAction)btnClicked:(UIButton *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:1];
    
}

- (IBAction)touchUpOutside:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor TaiheColor]];
}
- (IBAction)touchDown:(UIButton *)sender {
    sender.backgroundColor = [UIColor greenColor];
}

#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [super cellEditValueChangedWithTag:sender.tag AndValue:sender.text.intValue];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.feedCellTitle.frame = CGRectMake(0, 0, 80, 40);
//    self.feedNumTextField.frame = CGRectMake(self.frame.size.width/2-30, 4, 49, 36);
//    self.feedSwitch.frame = CGRectMake(self.frame.size.width-60, 6, 49, 31);
}

@end
