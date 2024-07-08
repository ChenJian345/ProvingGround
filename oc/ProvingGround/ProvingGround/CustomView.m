//
//  CustomView.m
//  UITest
//
//  Created by markcj on 13/09/2017.
//  Copyright © 2017 markcj. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"Custom View Init");
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    NSLog(@"Custom View init with frame");
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
