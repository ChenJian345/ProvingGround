//
//  MCLoginUserModel.m
//  ProvingGround
//
//  Created by Mark on 2020/10/14.
//  Copyright © 2020 markcj. All rights reserved.
//

#import "MCLoginUserModel.h"

@implementation MCLoginUserModel

- (void)login:(LoginSuccessBlock)successBlock failBlock:(LoginFailBlock)failBlock {
    if (successBlock) {
        NSDictionary *resultDic = @{
            @"token" : @"alfdjalku3o38089asfjkdaskljsfl1"
        };
        successBlock(resultDic);
    }
}

@end
