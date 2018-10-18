//
//  TableViewCellWithDefaultTitleLabel1Lable.m
//  thColorSort
//
//  Created by huanghu on 2018/2/26.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "TableViewCellWithDefaultTitleLabel1Lable.h"

@implementation TableViewCellWithDefaultTitleLabel1Lable

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20, 2, 150, 40);
    self.senseValueTitleLabel.frame = CGRectMake(self.frame.size.width-100, 4, 49, 36);
}

@end
