//
//  IRSharpenTableViewCell.h
//  thColorSort
//
//  Created by huanghu on 2017/12/7.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface IRSharpenTableViewCell : BaseTableViewCell<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *SharpenUseBtn;
@property (strong, nonatomic) IBOutlet BaseUITextField *SharpenEdit;

@end
