//
//  ColorDiffTypeAndReverseTitleTableViewCell.h
//  thColorSort
//
//  Created by huanghu on 2017/12/15.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ColorDiffTypeAndReverseTitleTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chuteTitle;
@property (strong, nonatomic) IBOutlet UILabel *senseValueTitle;
@property (strong, nonatomic) IBOutlet UILabel *senseLightUpperLimitValue;
@property (strong, nonatomic) IBOutlet UILabel *senseLightLowerLimitValue;
@property (strong, nonatomic) IBOutlet UILabel *reverseTitle;
@end
