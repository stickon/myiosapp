//
//  ColorTypeSenseValueTableViewCell.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/3/23.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface ColorTypeSenseValueTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chuteNum;
@property (strong, nonatomic) IBOutlet BaseUITextField*chuteSenseTimes1Value;
@property (strong, nonatomic) IBOutlet BaseUITextField*chuteSenseTimes2Value;
@end
