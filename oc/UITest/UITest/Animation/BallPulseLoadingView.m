//
//  BallPulseLoadingView.m
//  UITest
//
//  Created by markcj on 11/01/2018.
//  Copyright © 2018 markcj. All rights reserved.
//

#import "BallPulseLoadingView.h"
#import "ColorUtils.h"

#define DEFAULT_PADDING             3
#define DEFAULT_BALL_DIAMETER       3
#define BIGGEST_BALL_DIAMETER       7

static int stepFactor = 1;     // 默认递增1，当到最大index时，变为递减1，即-1

@interface BallPulseLoadingView()

@property (nonatomic, assign) int totalBallCount;               // total ball count in the animation
@property (nonatomic, assign) int fadeInBallEachSideCount;      // fade in ball count at each side of the animation

@property (nonatomic, strong) NSMutableArray *allMutLayers;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BallPulseLoadingView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self.allMutLayers == nil) {
        self.allMutLayers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setTotalBallCount:(int)totalCount fadeInBallCount:(int)eachFadeCount {
    if (self) {
        self.totalBallCount = totalCount;
        self.fadeInBallEachSideCount = eachFadeCount;
        self.biggestBallIndex = (int)(totalCount / 2);
        
        if (self.allMutLayers) {
            [self.allMutLayers removeAllObjects];
            
            for (int i = 0; i < self.totalBallCount; i++) {
                CAShapeLayer *pathLayer = [CAShapeLayer layer];
                pathLayer.lineWidth = 1;
                pathLayer.strokeColor = [[UIColor alloc] initWithRGBValue:0x34FFFE].CGColor;
                pathLayer.fillColor = [[UIColor alloc] initWithRGBValue:0x34FFFE].CGColor;
                [self.layer addSublayer:pathLayer];
                [self.allMutLayers addObject:pathLayer];
            }
        }
    }
}

- (void)createBalls {
    const float padding = DEFAULT_PADDING;  // 设定内边距为5
    const float ballDiameter = DEFAULT_BALL_DIAMETER;    // 球的大小
    const float biggestBallDiameter = BIGGEST_BALL_DIAMETER;
    const float steps = (biggestBallDiameter - ballDiameter) / self.fadeInBallEachSideCount;
    float currentBallDiameter = ballDiameter;
    
    float prevX = 0;
    float allBallsWidth = [self calculateAllBallsWidth];
    // 线的路径
    UIBezierPath *path = nil;
    CAShapeLayer *pathLayer = nil;
    for (int i = 0; i < self.totalBallCount; i++) {
        // 找到最大的
        if (self.biggestBallIndex == i) {
            currentBallDiameter = biggestBallDiameter;
        } else if (i >= self.biggestBallIndex - self.fadeInBallEachSideCount && i < self.biggestBallIndex) {    // 左侧渐变大
            currentBallDiameter = biggestBallDiameter - steps * (self.biggestBallIndex - i);
        } else if (i > self.biggestBallIndex && i <= self.biggestBallIndex + self.fadeInBallEachSideCount) {   // 右侧渐变小
            currentBallDiameter = biggestBallDiameter - steps * (i - self.biggestBallIndex);
        }
        
        float singleBallLayerWidth = currentBallDiameter + padding * 2;
        float singleBallHeight = currentBallDiameter;
        CGRect ballRect = CGRectMake(prevX+(CGRectGetWidth(self.bounds)-allBallsWidth)/2.0, (CGRectGetHeight(self.frame)-singleBallHeight)/2.0, currentBallDiameter, currentBallDiameter);
        path = [UIBezierPath bezierPathWithOvalInRect:ballRect];
        if (self.allMutLayers.count == self.totalBallCount) {
            pathLayer = [self.allMutLayers objectAtIndex:i];
            pathLayer.path = path.CGPath;
        }
        
        prevX += singleBallLayerWidth;
    }
}

/**
 计算一排球整个的宽度

 @return 所有球宽度值
 */
- (CGFloat)calculateAllBallsWidth {
    CGFloat result = 0;
    const float padding = DEFAULT_PADDING;  // 设定内边距为5
    const float ballDiameter = DEFAULT_BALL_DIAMETER;    // 球的大小
    const float biggestBallDiameter = BIGGEST_BALL_DIAMETER;
    const float steps = (biggestBallDiameter - ballDiameter) / self.fadeInBallEachSideCount;
    float currentBallDiameter = ballDiameter;

    for (int i = 0; i < self.totalBallCount; i++) {
        // 找到最大的
        if (self.biggestBallIndex == i) {
            currentBallDiameter = biggestBallDiameter;
        } else if (i >= self.biggestBallIndex - self.fadeInBallEachSideCount && i < self.biggestBallIndex) {    // 左侧渐变大
            currentBallDiameter = biggestBallDiameter - steps * (self.biggestBallIndex - i);
        } else if (i > self.biggestBallIndex && i <= self.biggestBallIndex + self.fadeInBallEachSideCount) {   // 右侧渐变小
            currentBallDiameter = biggestBallDiameter - steps * (i - self.biggestBallIndex);
        }
        result += currentBallDiameter + padding * 2;
    }
    return result;
}


/**
 更新最大的球的index，然后重新算其他球的尺寸，绘制动画
 */
- (void)updateBiggestBallIndex {
    self.biggestBallIndex += stepFactor;
    
    // 更新最大球Index
    int sideLeftNotChangeBallCount = self.fadeInBallEachSideCount + 1;
    if (self.biggestBallIndex >= (self.totalBallCount - sideLeftNotChangeBallCount)) {
        stepFactor = -1;
    } else if (self.biggestBallIndex <= sideLeftNotChangeBallCount-1) {
        stepFactor = 1;
    }
                                  
    [self createBalls];
}

- (void)startAnimation {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self updateBiggestBallIndex];
            [self sizeToFit];
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
