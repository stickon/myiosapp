//
//  TCPNetwork.h
//  thColorSort
//
//  Created by huanghuMacos on 2017/3/25.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "Network.h"
@interface TCPNetwork : Network<GCDAsyncSocketDelegate>
{
//    GCDAsyncSocket     *_tcpSocket;
    Byte ConnectType;//连接还是注册 0 1
}

@property (nonatomic,strong) GCDAsyncSocket *tcpSocket;
@end
