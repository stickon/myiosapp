//
//  ShapeMiniItemView.h
//  thColorSort
//
//  Created by 黄虎 on 2018/11/25.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUITextField.h"
@interface ShapeMiniItemView : UIView
@property (strong, nonatomic) IBOutlet UILabel *shapeMiniItemTitle;
@property (strong, nonatomic) IBOutlet UIButton *minusBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet BaseUITextField *valueEdit;
-(id)initWithFrame:(CGRect)frame;
@end
