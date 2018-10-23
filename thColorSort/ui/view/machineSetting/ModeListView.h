//
//  ModeListView.h
//  thColorSort
//
//  Created by huanghu on 2018/1/11.
//  Copyright © 2018年 huanghu. All rights reserved.
//

#import "BaseUI.h"

@interface ModeListModel:NSObject
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) Byte bigIndex;
@property(nonatomic,strong) NSString* smallIndex;
@property(nonatomic,copy) void(^dataUpdate)(void);
-(void)fetchData:(NSData*)data;
@end



@interface ModeListView : BaseUI
@property (nonatomic,assign) NSInteger selectRow;
@property (nonatomic,assign) NSInteger currentRow;
@end
