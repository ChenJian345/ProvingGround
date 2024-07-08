//
//  MCLoginUserModel.h
//  ProvingGround
//
//  Created by Mark on 2020/10/14.
//  Copyright © 2020 markcj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 登录成功回调
typedef void(^LoginSuccessBlock)(NSDictionary *dicResult);
typedef void(^LoginFailBlock)(NSDictionary *dicResult, NSInteger errorCode);

@interface MCLoginUserModel : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL isLogin; // 是否登录

- (void)login:(LoginSuccessBlock)SuccessBlock failBlock:(LoginFailBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
