//
//  MyGroupView.h
//  thColorSort
//
//  Created by huanghu on 2017/11/9.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GroupBtnDelegate<NSObject>
-(void)groupBtnClicked:(Byte)index;
@end
@interface MyGroupView : UIView{
    @public
    Byte groupNum;
}
@property (nonatomic,weak) id<GroupBtnDelegate> delegate;
- (void)setGroupNum:(NSInteger)num Title:(NSArray *)titleArr SelectedIndex:(Byte)selectedIndex;
@end
