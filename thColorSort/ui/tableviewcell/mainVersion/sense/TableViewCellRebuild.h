//
//  TableViewCellRebuild.h
//  thColorSort
//
//  Created by huanghu on 2018/9/21.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface TableViewCellRebuild : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UIButton *useBtn;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet BaseUITextField *itemSenseTextField;
-(void)setTextFieldMin:(NSInteger)min Max:(NSInteger)max;
@end
