//
//  JSONMergeUtil.h
//  ProvingGround
//
//  Created by Mark on 2019/4/29.
//  Copyright © 2019 markcj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONMergeUtil : NSObject

- (NSArray *)produceJsonStringArray;

- (NSArray *)mergeJSONString:(NSArray *)arrMetricsElement;

@end

NS_ASSUME_NONNULL_END
