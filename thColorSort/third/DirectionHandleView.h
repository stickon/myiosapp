//
//  DirectionHandleView.h
//  thColorSort
//
//  Created by huanghu on 2017/8/9.
//  Copyright © 2017年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DirectionHandleDelegate<NSObject>
-(void)directionHandle:(Byte)direction;
@end
@interface DirectionHandleView : UIView
@property (nonatomic,weak) id<DirectionHandleDelegate> delegate;
@end
