//
//  TableViewCellWith2Label.m
//  thColorSort
//
//  Created by huanghuMacos on 2017/4/12.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "TableViewCellWith2Label.h"

@implementation TableViewCellWith2Label

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
