//
//  BallPulseLoadingView.m
//  UITest
//
//  Created by markcj on 11/01/2018.
//  Copyright © 2018 markcj. All rights reserved.
//

#import "BallPulseLoadingView.h"

@implementation BallPulseLoadingView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self createBalls:3 fadeInCount:2 totalCount:7];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createBalls:(int)biggestBallIndex fadeInCount:(int)fadeInCount totalCount:(int)totalCount {
    const float padding = 5;  // 设定内边距为5
    const float ballDiameter = 20.0;    // 球的大小
    const float biggestBallDiameter = ballDiameter * 1.5;
    const float steps = (biggestBallDiameter - ballDiameter) / fadeInCount;
    float currentBallDiameter = ballDiameter;
    
    float prevX = 0;
    // 线的路径
    for (int i = 0; i < totalCount; i++) {
        // 找到最大的
        if (biggestBallIndex == i) {
            currentBallDiameter = biggestBallDiameter;
        } else if (i >= biggestBallIndex - fadeInCount && i < biggestBallIndex) {    // 左侧渐变大
            currentBallDiameter = biggestBallDiameter - steps * (biggestBallIndex - i);
        } else if (i > biggestBallIndex && i <= biggestBallIndex + fadeInCount) {   // 右侧渐变小
            currentBallDiameter = biggestBallDiameter - steps * (i-biggestBallIndex);
        } else {
            currentBallDiameter = ballDiameter;
        }
        NSLog(@"球的直径分别是： %d -> %.2f", i, currentBallDiameter);
        
        float singleBallLayerWidth = currentBallDiameter + padding * 2;
        CGRect ballRect = CGRectMake(prevX, (CGRectGetHeight(self.frame)-singleBallLayerWidth)/2.0, currentBallDiameter, currentBallDiameter);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ballRect];
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.lineWidth = 1;
        pathLayer.strokeColor = [UIColor redColor].CGColor;
        pathLayer.fillColor = [UIColor redColor].CGColor;
        pathLayer.path = path.CGPath;
        
        // 让所有球都垂直居中
        
        [self.layer addSublayer:pathLayer];
        
        prevX += singleBallLayerWidth;
    }
}

@end
