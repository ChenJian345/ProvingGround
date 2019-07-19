//
//  RACTestViewController.m
//  ProvingGround
//
//  Created by Mark on 2019/7/17.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "RACTestViewController.h"
#import <ReactiveObjC.h>

@interface RACTestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *editTextNum1;
@property (weak, nonatomic) IBOutlet UITextField *editTextNum2;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;

@end

@implementation RACTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC Test";
    // Do any additional setup after loading the view from its nib.
    
    // ---- Test 1 ----
    // Create a RACSignal object
//    RACSignal *racSig = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [subscriber sendNext:@"发送信号"];
//
//        return [RACDisposable disposableWithBlock:^{
//            // 信号被销毁
//            NSLog(@"信号被销毁");
//        }];
//    }];
//
//    [racSig subscribeNext:^(id  _Nullable x) {
//        NSLog(@"收到信号，信号值：%@", x);
//    }];
    
    // ---- Test 2 ----
//    [RACObserve(self.editTextNum1, text) subscribeNext:^(id  _Nullable x) {
//        [self calculatePlusResult];
//    }];
//
//    [RACObserve(self.editTextNum2, text) subscribeNext:^(id  _Nullable x) {
//        [self calculatePlusResult];
//    }];
    
    [[self.editTextNum1 rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        [self calculatePlusResult];
    }];
    
    [[self.editTextNum2 rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        [self calculatePlusResult];
    }];
    
    // 监听NSNotification
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"App进入前台啦，干活啦干活啦！");     // work!
    }];
    
    // 监听定时器
    @weakify(self)
    [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self)
        if ([self.lblResult.text isEqualToString:@"6.66"]) {
            NSLog(@"Bingo, Your are so lucky⛳️");   // work!
        }
    }];
    
    // 还可以用RACObserve创建信号来实现KVO监听等
}

- (void)calculatePlusResult {
    NSString *num1 = self.editTextNum1.text;
    NSString *num2 = self.editTextNum2.text;
    
    double result = 0.0;
    if (num1.length > 0 || num2.length > 0) {
        result = [num1 doubleValue] + [num2 doubleValue];
        self.lblResult.text = [NSString stringWithFormat:@"%.2f", result];
    } else {
        self.lblResult.text = @"0";
    }
}

@end
