//
//  SensorInfoModel.m
//  ProvingGround
//
//  Created by Mark on 2019/7/23.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "SensorInfoModel.h"

@interface SensorInfoModel()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CMPedometer *pedometer;   // 计步
@property (nonatomic, strong) CMMotionActivityManager *activityManager; // 运动状态

@end

@implementation SensorInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.pedometer = [[CMPedometer alloc] init];
        self.activityManager = [[CMMotionActivityManager alloc] init];
    }
    return self;
}

- (void)startMonitor {
    if (!self.motionManager) {
        return;
    }
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    // 陀螺仪
    if (self.motionManager.isGyroAvailable) {
        [self.motionManager setGyroUpdateInterval:1];
        [self.motionManager startGyroUpdatesToQueue:operationQueue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            if (!error) {
                if (gyroData) {
                    NSLog(@"陀螺仪数据：%@", gyroData);
                }
            } else {
                
            }
        }];
    } else {
        NSLog(@"陀螺仪不可用");
    }
    
    // 磁场传感器
    if (self.motionManager.isMagnetometerAvailable) {
        [self.motionManager setMagnetometerUpdateInterval:2];
        [self.motionManager startMagnetometerUpdatesToQueue:operationQueue withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            if (!error) {
                if (magnetometerData) {
                    NSLog(@"磁场传感器数据：%@", magnetometerData);
                }
            } else {
                
            }
        }];
    } else {
        NSLog(@"磁场传感器不可用");
    }
    
    // 设备信息
    if (self.motionManager.isDeviceMotionAvailable) {
        [self.motionManager setDeviceMotionUpdateInterval:3];
        [self.motionManager startDeviceMotionUpdatesToQueue:operationQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (!error) {
                if (motion) {
                    NSLog(@"设备状态数据: %@", motion);
                }
            } else {
                // Error
            }
        }];
    } else {
        NSLog(@"设备状态信息不可用");
    }
    
    // 加速度传感器
    if (self.motionManager.isAccelerometerAvailable) {
        [self.motionManager setAccelerometerUpdateInterval:4];
        [self.motionManager startAccelerometerUpdatesToQueue:operationQueue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (!error && accelerometerData) {
                NSLog(@"加速度传感器数据：%@", accelerometerData);
            } else {
                // Error
            }
        }];
    } else {
        NSLog(@"加速度传感器不可用");
    }
    
    // ---------------------------------------------
    if ([CMPedometer isStepCountingAvailable]) {
        [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (!error && pedometerData) {
                NSLog(@"计步器数据: %@", pedometerData);
            } else {
                // 计步器数据为空
            }
        }];
    } else {
        NSLog(@"计步器不可用");
    }
    
    // 运动状态
    if ([CMMotionActivityManager isActivityAvailable]) {
        [self.activityManager startActivityUpdatesToQueue:operationQueue withHandler:^(CMMotionActivity * _Nullable activity) {
            if (activity) {
                NSLog(@"运动状态信息： %@", activity);
            } else {
                // EMPTY DATA
            }
        }];
    } else {
        NSLog(@"运动状态信息不可用");
    }
}

- (void)stopMonitor {
    if (self.motionManager) {
        [self.motionManager stopGyroUpdates];
        [self.motionManager stopDeviceMotionUpdates];
        [self.motionManager stopMagnetometerUpdates];
        [self.motionManager stopAccelerometerUpdates];
    }
    
    if (self.pedometer) {
        [self.pedometer stopPedometerUpdates];
    }
    
    if (self.activityManager) {
        [self.activityManager stopActivityUpdates];
    }
}

@end
