//
//  ColorTypeSenseAndReverseTitleTableViewCell.h
//  thColorSort
//
//  Created by huanghu on 2017/12/8.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ColorTypeSenseAndReverseTitleTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chuteTitle;
@property (strong, nonatomic) IBOutlet UILabel *sortTimes1;
@property (strong, nonatomic) IBOutlet UILabel *sortTimes2;
@property (strong, nonatomic) IBOutlet UILabel *mirrorTitle;

@end
