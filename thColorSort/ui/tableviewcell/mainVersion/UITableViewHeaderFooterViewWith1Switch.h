//
//  UITableViewHeaderFooterViewWith1Switch.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/4/20.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwitchHeaderViewDelegate<NSObject>
-(void)switchHeaderInSection:(NSInteger)section withSwitchState:(Byte)state;
@end
@interface UITableViewHeaderFooterViewWith1Switch : UITableViewHeaderFooterView
@property(nonatomic, assign) NSInteger section;/**< 选中的section */
@property(nonatomic, weak) id<SwitchHeaderViewDelegate> delegate;/**< 代理 */
- (void)setSwitchSectionHeaderViewWithTitle:(NSString *)title section:(NSInteger)section switchState:(Byte)state hiddenSwitch:(BOOL)ishidden;

@end
