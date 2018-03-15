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

@property (nonatomic, strong) BallPulseLoadingView *ballPulseAniView;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Animations";
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(120, 80, 200, 40)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    [self.view addSubview:lblLoading];
    
    if (self.ballPulseAniView == nil) {
        self.ballPulseAniView = [[BallPulseLoadingView alloc] initWithFrame:CGRectMake(60, 120, 200, 20)];
        [self.view addSubview:self.ballPulseAniView];
        [self.ballPulseAniView setTotalBallCount:20 fadeInBallCount:3];
        
    }
    [self.ballPulseAniView startAnimation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.ballPulseAniView stopAnimation];
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
