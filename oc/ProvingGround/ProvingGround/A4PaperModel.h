//
//  A4PaperModel.h
//  UITest
//
//  Created by markcj on 14/09/2017.
//  Copyright © 2017 markcj. All rights reserved.
//

#import "PaperModel.h"

@interface A4PaperModel : PaperModel

@property (nonatomic, strong) NSString *paperName;

- (void)printSuperClassName;

-(void)thisASubClassInstanceMethod;

@end
