//
//  Rice20ValveSetTableViewCell.h
//  thColorSort
//
//  Created by huanghu on 2018/2/23.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UIComboBox.h"
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface Rice20ValveSetTableViewCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *groupTitleLabel;

@property (nonatomic,strong) UIComboBox<NSString*> *valveWorkModeComboBox;
@property (strong, nonatomic) IBOutlet UILabel *delayTimeTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *blowTimeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ejectTypeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *centerPointTitleLabel;


@property (strong, nonatomic) IBOutlet BaseUITextField *delayTimeTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *blowTimeTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ejectTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UISwitch *centerPointSwitch;

@property (strong, nonatomic) IBOutlet UILabel *valveOpenTimeLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *valveOpenTimeTextField;
@property (strong, nonatomic) IBOutlet UILabel *valveWorkModeTitleLabel;
@end
