//
//  MCLoginViewModel.h
//  ProvingGround
//
//  Created by Mark on 2020/10/14.
//  Copyright © 2020 markcj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCLoginUserModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCLoginViewModel : NSObject

@property (nonatomic, strong) MCLoginUserModel *user;

// 是否允许登录信号
@property (nonatomic, strong) RACSignal *enableLoginSignal;
// 执行登录动作命令
@property (nonatomic, strong) RACCommand *loginCommand;

@end

NS_ASSUME_NONNULL_END
