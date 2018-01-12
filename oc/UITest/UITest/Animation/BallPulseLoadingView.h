//
//  BallPulseLoadingView.h
//  UITest
//
//  Created by markcj on 11/01/2018.
//  Copyright © 2018 markcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallPulseLoadingView : UIView

@property (nonatomic, assign) int biggestBallIndex;             // Current biggest ball index, start from 0;

- (void)setTotalBallCount:(int)totalCount fadeInBallCount:(int)eachFadeCount;

- (void)startAnimation;

- (void)stopAnimation;

@end
