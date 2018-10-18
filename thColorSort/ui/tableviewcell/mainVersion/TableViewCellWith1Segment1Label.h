//
//  TableViewCellWith1Segment1Label.h
//  thColorSort
//
//  Created by huanghu on 2017/5/17.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface TableViewCellWith1Segment1Label :BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *frontViewLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *frontRearViewSegmentedControl;

@end
