//
//  TableViewCellWith4Label.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/4/12.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellWith4Label : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chuteTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *armVersionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fpgaVersionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *hardwareVersionTitleLabel;

@end
