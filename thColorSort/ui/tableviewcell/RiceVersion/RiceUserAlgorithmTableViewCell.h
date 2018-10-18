//
//  RiceUserAlgorithmTableViewCell.h
//  thColorSort
//
//  Created by huanghu on 2018/2/7.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface RiceUserAlgorithmTableViewCell : BaseTableViewCell
{
    @public
    Byte svmRange[4];
}
@property (strong, nonatomic) IBOutlet UILabel *riceUserAlgorithmNameLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *group1TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group2TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group3TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *group4TextField;
@property (strong, nonatomic) IBOutlet UISwitch *riceUserAlgorithmUseSwitch;
@property (strong, nonatomic) NSMutableArray<BaseUITextField*> *groupTextFieldArray;
@property (assign, nonatomic) Byte type;//算法类型，设置不同灵敏度范围
@end
