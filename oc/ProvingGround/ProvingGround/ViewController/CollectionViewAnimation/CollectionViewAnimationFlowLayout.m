//
//  CollectionViewAnimationFlowLayout.m
//  ProvingGround
//
//  Created by Mark on 2018/3/23.
//  Copyright © 2018年 markcj. All rights reserved.
//

#import "CollectionViewAnimationFlowLayout.h"

@implementation CollectionViewAnimationFlowLayout

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *resultAttr = [[UICollectionViewLayoutAttributes alloc] init];
    resultAttr.frame = CGRectMake(20, 20, 100, 100);
    return resultAttr;
}

@end
