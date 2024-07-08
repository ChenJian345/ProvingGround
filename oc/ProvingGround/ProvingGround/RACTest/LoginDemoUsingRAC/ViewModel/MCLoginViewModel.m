//
//  MCLoginViewModel.m
//  ProvingGround
//
//  Created by Mark on 2020/10/14.
//  Copyright © 2020 markcj. All rights reserved.
//

#import "MCLoginViewModel.h"
#import "MCLoginUserModel.h"

@interface MCLoginViewModel()

@end

@implementation MCLoginViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.user = [[MCLoginUserModel alloc] init];
        
        // 判断手机号和密码是否符合规则
        self.enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self.user, mobileNumber), RACObserve(self.user, password)] reduce:^id(NSString *mobilePhone, NSString *passwd){
            
            NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3|4|5|7|8][0-9]\\d{8}$"];
            NSPredicate *pwdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",  @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{4,8}"];
            
            
            return @([mobilePredicate evaluateWithObject:mobilePhone] && [pwdPredicate evaluateWithObject:passwd]);
        }];
        
        // 登录动作命令响应
        self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *resSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSLog(@"开始登录");
                
                // 登录操作
                [self.user login:^(NSDictionary * _Nonnull dicResult) {
                    if (dicResult.count > 0) {
                        self.user.token = [dicResult objectForKey:@"token"];
                        self.user.isLogin = YES;
                        
                        // TODO: - 其他数据略
                        
                        NSLog(@"开始登录 - 结果成功");
                    }
                } failBlock:^(NSDictionary * _Nonnull dicResult, NSInteger errorCode) {
                    // 登录失败
                    self.user.isLogin = NO;
                    
                    // TODO: - 登录失败其他操作
                    
                    NSLog(@"开始登录 - 结果失败");
                }];
                
                return nil;
            }];
            
            return resSignal;
        }];
    }
    return self;
}

@end
