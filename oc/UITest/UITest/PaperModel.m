//
//  PaperModel.m
//  UITest
//
//  Created by markcj on 13/09/2017.
//  Copyright © 2017 markcj. All rights reserved.
//

#import "PaperModel.h"
#import <objc/runtime.h>

@implementation PaperModel

- (void)printClassName {
    NSLog(@"Class Name : %@", [self class]);
}

@end
