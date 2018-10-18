//
//  Rice20SenseSizeTableViewCell.h
//  thColorSort
//
//  Created by huanghu on 2018/2/24.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyGroupView.h"
#import "BaseUITextField.h"
@interface Rice20SenseSizeTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *setSizeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lengthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *widthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *lengthTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *widthTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *sizeTextField;
@property (strong, nonatomic) IBOutlet UIButton *frontRearCheckbtn;
@property (strong, nonatomic) IBOutlet UILabel *frontRearTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *mirrorCheckBtn;
@property (strong, nonatomic) IBOutlet UILabel *mirrorTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *mirrorTextField;
@property (strong, nonatomic) IBOutlet UIButton *sharpenCheckBtn;
@property (strong, nonatomic) IBOutlet UILabel *sharpenTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *sharpenTextField;

@property (strong, nonatomic) IBOutlet MyGroupView *groupBtnsView;
@property (assign, nonatomic) Byte groupNum;
@property (assign, nonatomic) Byte currentGroupIndex;

-(void)updateSharpenHidden:(BOOL)hidden;

-(void)updateMirrorHidden:(BOOL)hidden;
@end
