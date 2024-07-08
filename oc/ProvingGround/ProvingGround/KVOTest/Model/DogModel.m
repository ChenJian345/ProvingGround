//
//  DogModel.m
//  RACTest
//
//  Created by Mark on 2019/5/17.
//  Copyright © 2019 Meituan Inc. All rights reserved.
//

#import "DogModel.h"
#import "objc/runtime.h"

/**
 [KVO缺点]
 苹果提供的KVO自身存在很多问题，首要问题在于，KVO如果使用不当很容易崩溃。
 例如重复add和remove导致的Crash，Observer被释放导致的崩溃，keyPath传错导致的崩溃等。
 
 在调用KVO时需要传入一个keyPath，由于keyPath是字符串的形式，所以其对应的属性发生改变后，
 字符串没有改变容易导致Crash。我们可以利用系统的反射机制将keyPath反射出来，这样编译器可以在@selector()中进行合法性检查。
 
 [KVOController]
 想在项目中安全便捷的使用KVO的话，推荐Facebook的一个KVO开源第三方框架-KVOController。
 KVOController本质上是对系统KVO的封装，具有原生KVO所有的功能，而且规避了原生KVO的很多问题，
 兼容block和action两种回调方式。
 */

@implementation DogModel

#pragma mark - KVO 手动触发
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    if ([key isEqualToString:@"name"]) {
//        return NO;
//    }
//    return [super automaticallyNotifiesObserversForKey:key];
//}

- (NSString *)description {
    return [NSString stringWithFormat:@"Current Class = %@, obj-class = %@",  [self class], object_getClass(self)];
}

@end
