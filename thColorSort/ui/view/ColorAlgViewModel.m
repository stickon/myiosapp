//
//  ColorAlgViewModel.m
//  thColorSort
//
//  Created by huanghu on 2018/10/30.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "ColorAlgViewModel.h"
#import "Network.h"
@implementation ColorAlgViewModel
- (instancetype)init {
    if(self = [super init]){
        self.FrontDataArray = [NSMutableArray array];
        self.RearDataArray = [NSMutableArray array];
        self.DataArray = [NSMutableArray arrayWithObjects:self.FrontDataArray,self.RearDataArray,nil];
    }
    return self;
}
- (void)fetchData:(NSData*)data{
    const char *a = data.bytes;
    SocketHeader header;
    memcpy(&header, a, Socket_Header_Length);
    if (header.type == 0x07 && header.extendType == 0x01) {
        [self.FrontDataArray removeAllObjects];
        [self.RearDataArray removeAllObjects];
        NSInteger algCount = (data.length-Socket_Header_Length)/sizeof(ColorAlg);
        ColorAlg *alg = malloc(sizeof(ColorAlg)*algCount);
        memcpy(alg, a+Socket_Header_Length, data.length-Socket_Header_Length);
        for (int i = 0;i<algCount;i++) {
            NSNumber *senseValue = @(alg[i].sense[0]*256+alg[i].sense[1]);
            NSNumber *senseMin = @(alg[i].senseMin[0]*256+alg[i].senseMin[1]);
            NSNumber *senseMax =@(alg[i].senseMax[0]*256+alg[i].senseMax[1]);
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @(alg[i].used),@"useState",\
                                 [NSString stringWithUTF8String:(const char*)(alg[i].name)],@"algName",senseValue,@"senseValue",\
                                 senseMin,@"senseMin",senseMax,@"senseMax",@(alg[i].type),@"type",\
                                 @(alg[i].subType),@"subType",@(alg[i].extType),@"extType",nil];
        
             [[self.DataArray objectAtIndex:alg[i].view] addObject:dic];
        }
        free(alg);
    }
    if (self.dataUpdate) {
        self.dataUpdate();
    }
}

@end
