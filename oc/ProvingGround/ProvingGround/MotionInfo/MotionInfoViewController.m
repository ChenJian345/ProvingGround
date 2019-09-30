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

@property (weak, nonatomic) IBOutlet UITextView *tvConsole;

@end

@implementation MotionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tvConsole.text = @"";
    
    // 初始化组件
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.activityManager = [[CMMotionActivityManager alloc] init];

    [self startActivityMonitor];
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
}

#pragma mark - 运动状态
- (void)startActivityMonitor {
    if (self.activityManager && [CMMotionActivityManager isActivityAvailable]) {
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
            
            [self appendToConsole:newText];
        }];
    } else {
        NSLog(@"运动状态不可用!!");
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *oldText = self.tvConsole.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        NSString *time = [formatter stringFromDate:[NSDate date]];
        
        if (oldText.length <= 0) {
            self.tvConsole.text = [NSString stringWithFormat:@"%@=> %@", time, newText];
        } else {
            self.tvConsole.text = [NSString stringWithFormat:@"%@\n%@=> %@", oldText, time, newText];
        }
    });
}


@end
