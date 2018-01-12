//
//  AnimationViewController.m
//  UITest
//
//  Created by Mark on 2018/1/12.
//  Copyright © 2018年 markcj. All rights reserved.
//

#import "AnimationViewController.h"
#import "BallPulseLoadingView.h"

@interface AnimationViewController ()

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __block BallPulseLoadingView *ballPulseAniView = [[BallPulseLoadingView alloc] initWithFrame:CGRectMake(0, 200, 200, 20)];
    ballPulseAniView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:ballPulseAniView];
    [ballPulseAniView setTotalBallCount:10 fadeInBallCount:2];
    [ballPulseAniView startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
