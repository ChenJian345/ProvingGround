//
//  BallPulseLoadingView.m
//  UITest
//
//  Created by markcj on 11/01/2018.
//  Copyright © 2018 markcj. All rights reserved.
//

#import "BallPulseLoadingView.h"

static int stepFactor = 1;     // 默认递增1，当到最大index时，变为递减1，即-1

@interface BallPulseLoadingView()

@property (nonatomic, assign) int totalBallCount;               // total ball count in the animation
@property (nonatomic, assign) int fadeInBallEachSideCount;      // fade in ball count at each side of the animation

@property (nonatomic, strong) NSMutableArray *allMutLayers;

//@property (nonatomic, strong) NSArray *arrBallData;
//@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BallPulseLoadingView

- (void)setTotalBallCount:(int)totalCount fadeInBallCount:(int)eachFadeCount {
    if (self) {
        self.totalBallCount = totalCount;
        self.fadeInBallEachSideCount = eachFadeCount;
        self.biggestBallIndex = (int)(totalCount / 2);
        
        if (self.allMutLayers == nil) {
            self.allMutLayers = [[NSMutableArray alloc] init];
        }
    }
}

- (void)createBalls {
    const float padding = 5;  // 设定内边距为5
    const float ballDiameter = 10;    // 球的大小
    const float biggestBallDiameter = ballDiameter * 1.5;
    const float steps = (biggestBallDiameter - ballDiameter) / self.fadeInBallEachSideCount;
    float currentBallDiameter = ballDiameter;

    for (CALayer *layer in self.allMutLayers) {
        [layer removeFromSuperlayer];
    }
    
    float prevX = 0;
    // 线的路径
    for (int i = 0; i < self.totalBallCount; i++) {
    
        // 找到最大的
        if (self.biggestBallIndex == i) {
            currentBallDiameter = biggestBallDiameter;
        } else if (i >= self.biggestBallIndex - self.fadeInBallEachSideCount && i < self.biggestBallIndex) {    // 左侧渐变大
            currentBallDiameter = biggestBallDiameter - steps * (self.biggestBallIndex - i);
        } else if (i > self.biggestBallIndex && i <= self.biggestBallIndex + self.fadeInBallEachSideCount) {   // 右侧渐变小
            currentBallDiameter = biggestBallDiameter - steps * (i - self.biggestBallIndex);
        } else {
            currentBallDiameter = ballDiameter;
        }
//        NSLog(@"球的直径分别是： %d -> %.2f", i, currentBallDiameter);
        
        float singleBallLayerWidth = currentBallDiameter + padding * 2;
        CGRect ballRect = CGRectMake(prevX, (CGRectGetHeight(self.frame)-singleBallLayerWidth)/2.0, currentBallDiameter, currentBallDiameter);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ballRect];
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.lineWidth = 1;
        pathLayer.strokeColor = [UIColor redColor].CGColor;
        pathLayer.fillColor = [UIColor redColor].CGColor;
        pathLayer.path = path.CGPath;
        
        // 更新Layer
        [self.allMutLayers addObject:pathLayer];
        
        // 让所有球都垂直居中
        
        [self.layer addSublayer:pathLayer];
        
        prevX += singleBallLayerWidth;
        
        [self sizeToFit];
    }
}

- (void)updateBiggestBallIndex {
    
    
    self.biggestBallIndex += stepFactor;
    
    int sideLeftNotChangeBallCount = self.fadeInBallEachSideCount + 1;
    if (self.biggestBallIndex >= (self.totalBallCount - sideLeftNotChangeBallCount)) {
        stepFactor = -1;
    } else if (self.biggestBallIndex <= sideLeftNotChangeBallCount) {
        stepFactor = 1;
    }
    
    NSLog(@"当前最大球的Index = %d", self.biggestBallIndex);
                                  
    [self createBalls];
}

- (void)startAnimation {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self updateBiggestBallIndex];
        }];
    }
}

- (void)stopAnimation {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
