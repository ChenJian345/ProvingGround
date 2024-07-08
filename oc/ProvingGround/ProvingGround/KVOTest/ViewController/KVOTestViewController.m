//
//  KVOTestViewController.m
//  RACTest
//
//  Created by Mark on 2019/7/16.
//  Copyright © 2019 Meituan Inc. All rights reserved.
//

#import "KVOTestViewController.h"
#import "DogModel.h"

@interface KVOTestViewController ()

@property (nonatomic, strong) DogModel *dog;

@end

@implementation KVOTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KVO Test";
    // Do any additional setup after loading the view from its nib.
    self.dog = [[DogModel alloc] init];
    
    [self.dog addObserver:self
               forKeyPath:@"name"
                  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)  // NSKeyValueObservingOptionInitial
                  context:nil];
}

- (void)dealloc {
    NSLog(@"dealloc executed");
    [self.dog removeObserver:self forKeyPath:@"name" context:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"值变了, keyPath = %@, change = %@, Dog Class : %@", keyPath, change, self.dog);
}

- (IBAction)didChangeNameButtonClick:(id)sender {
    self.dog.name = [[NSUUID UUID] UUIDString];
    
    // 手动触发时，需要调用方法
//    [self.dog willChangeValueForKey:@"name"];
//    self.dog.name = [[NSUUID UUID] UUIDString];
//    [self.dog didChangeValueForKey:@"name"];
}

@end
