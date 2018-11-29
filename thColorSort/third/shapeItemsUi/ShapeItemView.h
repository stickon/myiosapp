//
//  ShapeItemView.h
//  thColorSort
//
//  Created by 黄虎 on 2018/11/25.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShapeItemView : UIView
@property (strong, nonatomic) IBOutlet UIButton *shapeItemCheckbtn;
@property (strong, nonatomic) IBOutlet UILabel *shapeItemTitle;
-(id)initWithFrame:(CGRect)frame;
@end
