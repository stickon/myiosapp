//
//  ColorAlgViewModel.h
//  thColorSort
//
//  Created by huanghu on 2018/10/30.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorAlgViewModel : NSObject
@property(nonatomic,strong) NSMutableArray *FrontDataArray;
@property(nonatomic,strong) NSMutableArray *RearDataArray;
@property(nonatomic,strong) NSMutableArray *DataArray;
@property (nonatomic, copy) void(^dataUpdate)(void);

-(void)fetchData:(NSData*)data;
@end

NS_ASSUME_NONNULL_END
