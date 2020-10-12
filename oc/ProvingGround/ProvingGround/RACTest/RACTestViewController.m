//
//  RACTestViewController.m
//  ProvingGround
//
//  Created by Mark on 2019/7/17.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "RACTestViewController.h"
#import <ReactiveObjC.h>
#import "MCLoginDemoViewController.h"

@interface RACTestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *editTextNum1;
@property (weak, nonatomic) IBOutlet UITextField *editTextNum2;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UIButton *btnAlertView;

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
    
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        NSLog(@"Bingo, task triggerred after 4 seconds.");
    }];
    
    // 监听View的点击时间
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tapGR];
    [tapGR.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"点击了View");
    }];
    
    // 还可以用RACObserve创建信号来实现KVO监听等
    [RACObserve(self, valueForRACObserve) subscribeNext:^(id  _Nullable x) {
        NSLog(@"RAC KVO Observe, valueForRACObserve value has been changed! the new value is %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"[Error] RAC KVO Observe, valueForRACObserve value has been changed!");
    }];
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

- (IBAction)btnAlertView:(id)sender {
    UIAlertController *alertCtrler = [UIAlertController alertControllerWithTitle:@"提示" message:@"RAC Alert点击监听" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 修改KVO监听的Value值
        self.valueForRACObserve = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
        
        // 测试创建信号操作
        [self createRACSignalAndSubscribe];
        
        // 测试命令操作
        [self createRACCommandAndUse];
    }];
    [alertCtrler addAction:actionOK];
    [self.navigationController presentViewController:alertCtrler animated:YES completion:nil];
}

- (IBAction)didLoginDemoButtonClicked:(id)sender {
    MCLoginDemoViewController *loginDemoVC = [[MCLoginDemoViewController alloc] init];
    [self.navigationController pushViewController:loginDemoVC animated:YES];
}

#pragma mark - RAC进阶
// RAC核心类: RACSignal
// 创建信号 -> 激活信号 -> 废弃信号
- (void)createRACSignalAndSubscribe {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 发信号，订阅的地方会处理
        NSLog(@"发送信号");
        [subscriber sendNext:@"this is a string"];
        
        // 发送完成
        NSLog(@"发送完成");
        [subscriber sendCompleted];
        
        // 销毁信号
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号已销毁");
        }];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收数据, %@", x);
    }];
}

// 处理事件的类：RACCommand
// 用于监听事件点击、网络请求等，可以把事件如何处理，事件中的数据如何传递等包装到这个类中。
//
- (void)createRACCommandAndUse {
    RACCommand *racCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       
        // 执行动作命令
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [racCmd.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"执行命令");
    }];
    
    [racCmd execute:@"命令内容"];
}

#pragma mark - RAC常见宏

// RAC(TARGET, [KEYPATH, [NIL_VALUE]]=…
// 将两个对象属性进行绑定，一个对象的属性一旦发生变化，自动触发绑定的对象属性变更

// RACObserve(TARGET, [KEYPATH])
// 用于监听某个对象的某个属性,返回信号。上面有使用案例

@end
