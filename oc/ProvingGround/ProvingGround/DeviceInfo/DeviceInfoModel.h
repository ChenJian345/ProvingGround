//
//  DeviceInfoModel.h
//  ProvingGround
//
//  Created by Mark on 2019/7/19.
//  Copyright © 2019 markcj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;


+ (NSArray *)getGeneralDeviceInfo;

+ (NSArray *)getAppInfo;

+ (NSArray *)getHardwareInfo;

+ (NSArray *)getNetworkInfo;

+ (NSArray *)getAdvertisementInfo;

+ (NSArray *)getDiskInfo;

+ (NSArray *)getCPUInfo;

@end

NS_ASSUME_NONNULL_END
