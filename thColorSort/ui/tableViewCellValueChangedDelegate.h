//
//  tableViewCellValueChangedDelegate.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/3/28.
//  Copyright © 2017年 charles. All rights reserved.
//

#ifndef tableViewCellValueChangedDelegate_h
#define tableViewCellValueChangedDelegate_h

#import <UIKit/UIKit.h>
@protocol TableViewCellChangedDelegate <NSObject>
@optional
-(void)cellBtnClicked:(long)section row:(long)row tag:(long)tag value:(NSInteger)value bSend:(BOOL)bsend;
@required
-(void)cellValueChangedWithSection:(long)section row:(long)row tag:(long)index value:(NSInteger)value;
@end
#endif /* tableViewCellValueChangedDelegate_h */
