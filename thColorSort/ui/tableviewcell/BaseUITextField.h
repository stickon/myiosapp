//
//  BaseUITextField.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/4/27.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMNumberKeyboard.h"
@class BaseUITextField;
@protocol MyTextFieldDelegate<NSObject>
-(void)mytextfieldDidEnd:(BaseUITextField*)sender;
@end
@interface BaseUITextField : UITextField
-(void)configInputView;
-(void)initKeyboardWithMax:(NSInteger)max Min:(NSInteger)min Value:(NSInteger)value;
@property (nonatomic,weak) id<MyTextFieldDelegate> mydelegate;
-(void)displayView;
@end
