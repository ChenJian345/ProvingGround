//
//  UIViewAnimationTestViewController.m
//  UITest
//
//  Created by markcj on 05/03/2018.
//  Copyright © 2018 markcj. All rights reserved.
//

#import "UIViewAnimationTestViewController.h"

typedef enum : NSUInteger {
    TrafficLightColorRed        = 0x01,
    TrafficLightColorGreen,
    TrafficLightColorYellow,
} TrafficLightColor;

@interface UIViewAnimationTestViewController ()

@property (nonatomic, strong) UIImageView *ivTrafficLight;
@property (nonatomic, assign) TrafficLightColor currentColorType;

@end

@implementation UIViewAnimationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UIView Animation";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.ivTrafficLight = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.ivTrafficLight.clipsToBounds = YES;
    self.ivTrafficLight.layer.cornerRadius = 100;
    [self.view addSubview:self.ivTrafficLight];
    
    self.currentColorType = TrafficLightColorGreen;
    self.ivTrafficLight.backgroundColor = [UIColor greenColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self) wSelf = self;
    
    [wSelf updateTheTrafficLight:TrafficLightColorRed];
//    [wSelf updateTheTrafficLight:TrafficLightColorYellow];
//    [wSelf updateTheTrafficLight:TrafficLightColorGreen];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf updateTheTrafficLight:TrafficLightColorGreen];
//    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf updateTheTrafficLight:TrafficLightColorYellow];
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTheTrafficLight:(TrafficLightColor)color {
    [UIView animateWithDuration:0.1 animations:^{
        switch (color) {
            case TrafficLightColorRed:
            {
                self.ivTrafficLight.backgroundColor = [UIColor redColor];
            }
                break;
                
            case TrafficLightColorGreen:
            {
                self.ivTrafficLight.backgroundColor = [UIColor greenColor];
            }
                break;
                
            case TrafficLightColorYellow:
            {
                self.ivTrafficLight.backgroundColor = [UIColor yellowColor];
            }
                break;
                
            default:
                break;
        }
        
        NSLog(@"Current color type = %ld", color);
    } completion:^(BOOL finished) {
        NSLog(@"completion CALLED ---- %ld", color);
        if (finished) {
            self.currentColorType = color;
            NSLog(@"Current color type = %ld FINISH", self.currentColorType);
        }
    }];
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
