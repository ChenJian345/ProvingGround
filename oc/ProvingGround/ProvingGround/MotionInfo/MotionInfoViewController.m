//
//  MotionInfoViewController.m
//  ProvingGround
//
//  Created by Mark on 2019/9/29.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "MotionInfoViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface MotionInfoViewController ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) CMMotionActivityManager *activityManager; // 运动状态
@property (nonatomic, strong) CMMotionManager *motionManager;   // 运动传感器Manager
@property (nonatomic, strong) CMAltimeter *altimeter;           // 高度传感器

@property (weak, nonatomic) IBOutlet UITextView *tvConsole;

@end

@implementation MotionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CoreMotion";
    self.tvConsole.text = @"";
    
    // 初始化组件
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.activityManager = [[CMMotionActivityManager alloc] init];
    self.altimeter = [[CMAltimeter alloc] init];
    
    // 运动传感器
    self.motionManager = [[CMMotionManager alloc] init];
    
    
    // 运动状态判断检测
    [self startActivityMonitor];
    
    // 加速度，陀螺仪
    // [self startSensorMotionMonitor];
    
    // 处理后的设备运动状态信息
    [self startProcessedDeviceMotionDataMonitor];
}

- (void)dealloc {
    NSLog(@"MotionInfoViewController dealloc excute");
    
    if (self.activityManager) {
        [self.activityManager stopActivityUpdates];
        self.activityManager = nil;
    }
    
    if (self.operationQueue) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    
    // 停止传感器更新
    [self stopSensorMotionMonitor];
}

#pragma mark - 运动状态
- (void)startActivityMonitor {
    if (self.activityManager && [CMMotionActivityManager isActivityAvailable]) {
        __weak typeof(self) weakSelf = self;
        [self.activityManager startActivityUpdatesToQueue:self.operationQueue withHandler:^(CMMotionActivity * _Nullable activity) {
            NSLog(@"Motion Activity : %@", activity);
            
            NSString *newText = nil;
            if (activity.running) {
                newText = @"跑步 -- 🏃🏃";
            } else if (activity.walking) {
                newText = @"步行 -- 🚶🚶";
            } else if (activity.cycling) {
                newText = @"骑行 -- 🚴🚴";
            } else if (activity.automotive) {
                newText = @"驾车 -- 🚗🚐";
            } else if (activity.stationary) {
                newText = @"静止不动";
            } else {
                newText = @"未知状态";
            }
            
            if (activity.confidence == CMMotionActivityConfidenceHigh) {
                newText = [newText stringByAppendingString:@" - 准确度： 高"];
            } else if (activity.confidence == CMMotionActivityConfidenceLow) {
                newText = [newText stringByAppendingString:@" - 准确度： 低"];
            } else if (activity.confidence == CMMotionActivityConfidenceMedium) {
                newText = [newText stringByAppendingString:@" - 准确度： 中"];
            } else {
                newText = [newText stringByAppendingString:@" - 准确度： 未知"];
            }
            
            [weakSelf appendToConsole:newText];
        }];
    } else {
        [self appendToConsole:@"❎ 运动状态不可用!"];
    }
}

- (void)stopActivityMonitor {
    if (self.activityManager) {
        [self.activityManager stopActivityUpdates];
    }
}

- (void)appendToConsole:(NSString *)newText {
    if (newText.length <= 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *oldText = self.tvConsole.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        NSString *time = [formatter stringFromDate:[NSDate date]];
        
        if (oldText.length <= 0) {
            weakSelf.tvConsole.text = [NSString stringWithFormat:@"%@=> %@", time, newText];
        } else {
            weakSelf.tvConsole.text = [NSString stringWithFormat:@"%@\n%@=> %@", oldText, time, newText];
        }
        
        
        NSRange bottom = NSMakeRange(weakSelf.tvConsole.text.length -1, 1);
        [weakSelf.tvConsole scrollRangeToVisible:bottom];
    });
}

#pragma mark - 陀螺仪
// 获取DeviceMotion相关数据
- (BOOL)startSensorMotionMonitor {
    if (self.motionManager && self.motionManager.isDeviceMotionAvailable) {
        __weak typeof(self) weakSelf = self;
        
        // ----------------- 陀螺仪 -----------------
        // 陀螺仪更新速率，单位s
        self.motionManager.gyroUpdateInterval = 5;
        
        // 需要时采集数据
        //        [self.motionManager startGyroUpdates];
        //        self.motionManager.gyroData
        
        // 数据实时更新
        [self.motionManager startGyroUpdatesToQueue:self.operationQueue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            NSString *txtGyroData = [NSString stringWithFormat:@"陀螺仪 x = %f, y = %f, z = %f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z];
            NSLog(@"%@", txtGyroData);
            [weakSelf appendToConsole:txtGyroData];
        }];
        
        // ----------------- 加速度计 -----------------
        // 设置采样频率
        self.motionManager.accelerometerUpdateInterval = 5.0;
        
        //        // 需要时采集
        //        [self.motionManager startAccelerometerUpdates]
        //        self.motionManager.accelerometerData
        
        // 实时更新
        [self.motionManager startAccelerometerUpdatesToQueue:self.operationQueue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            NSString *str = [NSString stringWithFormat:@"加速度 x=%f, y=%f, z=%f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z];
            NSLog(@"%@", str);
            [weakSelf appendToConsole:str];
        }];
        
        // ----------------- 磁力计 -----------------
        self.motionManager.magnetometerUpdateInterval = 5.0;
        [self.motionManager startMagnetometerUpdatesToQueue:self.operationQueue withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            NSString *str = [NSString stringWithFormat:@"磁力计 x=%f, y=%f, z=%f", magnetometerData.magneticField.x, magnetometerData.magneticField.y, magnetometerData.magneticField.z];
            NSLog(@"%@", str);
            [weakSelf appendToConsole:str];
        }];
        
        
        // ----------------- DeviceMotion -----------------
        self.motionManager.deviceMotionUpdateInterval = 5.0;
        [self.motionManager startDeviceMotionUpdatesToQueue:self.operationQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            NSString *str = [NSString stringWithFormat:@"DeviceMotion = %@", motion];
            NSLog(@"%@", str);
            [weakSelf appendToConsole:str];
        }];
        
        return YES;
    } else {
        [self appendToConsole:@"❎ 设备传感器不可用！"];
        return NO;
    }
}

- (void)stopSensorMotionMonitor {
    if (self.motionManager && self.motionManager.isDeviceMotionAvailable) {
        if (self.motionManager.isGyroActive) {
            [self.motionManager stopGyroUpdates];
        }
    }
}

#pragma mark - 处理后的Device Motion Data
- (BOOL)startProcessedDeviceMotionDataMonitor {
    if (self.altimeter && [CMAltimeter isRelativeAltitudeAvailable]) {
        if (@available(iOS 11.0, *)) {
            if ([CMAltimeter authorizationStatus] != CMAuthorizationStatusAuthorized) {
                [self appendToConsole:@"获取高度未被授权"];
            }
        } else {
            // Fallback on earlier versions
        }
        
        [self.altimeter startRelativeAltitudeUpdatesToQueue:self.operationQueue withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            NSString *str = [NSString stringWithFormat:@"高度计 : relativeAltitude = %@ 米, 气压 = %@ kPa", altitudeData.relativeAltitude, altitudeData.pressure];
            NSLog(@"%@", str);
            [self appendToConsole:str];
        }];
    }
    
    return YES;
}

- (void)stopProcessedDeviceMotionDataMonitor {
    if (self.altimeter && [CMAltimeter isRelativeAltitudeAvailable]) {
        [self.altimeter stopRelativeAltitudeUpdates];
    }
}

@end
