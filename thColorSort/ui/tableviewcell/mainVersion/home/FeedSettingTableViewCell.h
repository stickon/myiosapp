//
//  FeedSettingTableViewCell.h
//  thColorSort
//
//  Created by huanghu on 2017/6/26.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface FeedSettingTableViewCell : BaseTableViewCell<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *feedCellTitle;
@property (strong, nonatomic) IBOutlet BaseUITextField *feedNumTextField;
@property (strong, nonatomic) IBOutlet UISwitch *feedSwitch;
@property (strong, nonatomic) IBOutlet UIButton *minusBtn;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn;

@end
