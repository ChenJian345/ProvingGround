//
//  A4PaperModel.m
//  UITest
//
//  Created by markcj on 14/09/2017.
//  Copyright © 2017 markcj. All rights reserved.
//

#import "A4PaperModel.h"

@implementation A4PaperModel

-(instancetype)init {
    self = [super init];
    
    // Init
    self.paperName = @"";
    
    return self;
}

-(void)setPaperName:(NSString *)paperName {
    if (paperName != nil && self.paperName != paperName) {
        _paperName = paperName;
    }
}

- (void)printSuperClassName {
    [super printClassName];
    
    NSLog(@"Super class name = %@", [super class]);
    NSLog(@"Sub class name = %@", ([self class]));
}

-(void)thisASubClassInstanceMethod {
    NSLog(@"This is a sub class instance method");
}

@end
