//
//  TableViewCellWithDefaultLabel2Button.m
//  thColorSort
//
//  Created by huanghu on 2017/5/6.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "TableViewCellWithDefaultLabel2Button.h"

@implementation TableViewCellWithDefaultLabel2Button

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.frame = CGRectMake(0, 0, 0, 20);
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
    self.applyBtn.layer.cornerRadius = 3.0f;
    self.configBtn.layer.cornerRadius = 3.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellValueChangedWithSection:row:tag:value:)]) {
        [self.delegate cellValueChangedWithSection:self.indexPath.section row:self.indexPath.row tag:sender.tag value:1];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds =CGRectMake(0,2,35,35);
    self.imageView.frame =CGRectMake(0,2,35,35);
    self.imageView.contentMode =UIViewContentModeScaleAspectFit;
}

@end
