//
//  SensorInfoModel.h
//  ProvingGround
//
//  Created by Mark on 2019/7/23.
//  Copyright © 2019 markcj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreMotion/CMStepCounter.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorInfoModel : NSObject

- (void)startMonitor;

- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
