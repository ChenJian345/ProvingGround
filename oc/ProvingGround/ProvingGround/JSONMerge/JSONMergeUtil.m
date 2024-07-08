//
//  JSONMergeUtil.m
//  ProvingGround
//
//  Created by Mark on 2019/4/29.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "JSONMergeUtil.h"

@implementation JSONMergeUtil

- (NSArray *)produceJsonStringArray {
    // 测试JSON Merge数据
    NSString *json1 = @"{\"kvs\":{\"locationSuccess\":[1]},\"tags\":{\"systemVersion\":\"12.1\",\"osType\":2,\"appType\":3,\"appVersion\":\"4.9.6\",\"city\":-1,\"from\":\"gps\"},\"ts\":1554371638}";
    NSString *json2 = @"{\"kvs\":{\"locationFail\":[1]},\"tags\":{\"systemVersion\":\"12.1\",\"osType\":2,\"appType\":3,\"appVersion\":\"4.9.6\",\"city\":-1,\"from\":\"gps\"},\"ts\":1554371638}";
    NSString *json3 = @"{\"kvs\":{\"mapShowSuccess\":[1]},\"tags\":{\"systemVersion\":\"12.1\",\"osType\":2,\"appType\":3,\"appVersion\":\"4.9.6\",\"city\":-1,\"from\":\"gps\"},\"ts\":1554371638}";
    NSString *json4 = @"{\"kvs\":{\"mapShowError\":[1]},\"tags\":{\"systemVersion\":\"12.1\",\"osType\":2,\"appType\":3,\"appVersion\":\"4.9.6\",\"city\":-1,\"from\":\"gps\"},\"ts\":1554371638}";
    
    NSArray *arrJson = @[json1, json2, json3, json4];
    NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:1000000];
    for (int i = 0; i<250000; i++) {
        [arrResult addObjectsFromArray:arrJson];
    }
    
    return [arrResult copy];
}

/**
 *  为节省流量，将相同的JSON字符串进行合并，并修改JSON字符串中的key值, 例如：
 *
 *    {
 *      "kvs": {
 *        "locationSuccess": [
 *          1
 *        ]
 *      },
 *      "tags": {
 *        "systemVersion": "12.1",
 *        "osType": 2,
 *        "appType": 3,
 *        "appVersion": "4.9.6",
 *        "city": -1,
 *        "from": "gps"
 *      },
 *      "ts": 1554371638
 *    }
 *
 *    {
 *      "kvs": {
 *        "locationSuccess": [
 *          1
 *        ]
 *      },
 *      "tags": {
 *        "systemVersion": "12.1",
 *        "osType": 2,
 *        "appType": 3,
 *        "appVersion": "4.9.6",
 *        "city": -1,
 *        "from": "gps"
 *      },
 *      "ts": 1554371638
 *    }
 *
 *  转换为
 *
 *    {
 *      "kvs": {
 *        "locationSuccess": [
 *          1, 1        <------ 注意此处变化
 *        ]
 *      },
 *      "tags": {
 *        "systemVersion": "12.1",
 *        "osType": 2,
 *        "appType": 3,
 *        "appVersion": "4.9.6",
 *        "city": -1,
 *        "from": "gps"
 *      },
 *      "ts": 1554371638
 *    }
 
 @param arrMetricsElement 要上传的数据记录
 @return 整理后的数据记录数组
 */
- (NSArray *)mergeJSONString:(NSArray *)arrMetricsElement {
    if (arrMetricsElement == nil || arrMetricsElement.count == 0) {
        return nil;
    }
    NSMutableDictionary *dicJSONAndCount = [[NSMutableDictionary alloc] init];
    
    int count = 0;
    for (int i = 0; i < arrMetricsElement.count; i++) {
        NSString *jsonStr = [arrMetricsElement objectAtIndex:i];
        
        if ([dicJSONAndCount objectForKey:jsonStr]) {
            continue;
        }
        
        count = 1;
        for (int j = i+1; j < arrMetricsElement.count; j++) {
            if ([jsonStr isEqualToString:[arrMetricsElement objectAtIndex:j]]) {
                count++;
            }
        }
        
        [dicJSONAndCount setObject:@(count) forKey:jsonStr];
    }
    
    // 将数据中的key对应的值修改为count个1
    NSMutableArray *resultNewMetricsElement = [[NSMutableArray alloc] init];
    for (NSString *jsonKey in dicJSONAndCount) {
        NSInteger count = [[dicJSONAndCount objectForKey:jsonKey] integerValue];
        if (count > 1) {    // 如果这个json对应的条数大于1，则重新调整数据格式
            NSMutableArray *arrCount = [[NSMutableArray alloc] init];
            for (int j = 0; j < count; j++) {
                // 例如count = 4，转换结果为： [1, 1, 1, 1]
                [arrCount addObject:@(1)];
            }
            
            // 将原来JSONKey的字符串替换, 并加入到结果数组中
            NSData *jsonData = [jsonKey dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSMutableDictionary *dicJson = [[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] mutableCopy];
            if (error == nil) {
                // 将原jsonString中的kvs-「locationSuccess等key」字段值，替换为上面的次数数组
                NSDictionary *dicKVS = [dicJson objectForKey:@"kvs"];
                NSMutableDictionary *newDicKVS = [dicKVS mutableCopy];
                if (dicKVS != nil && dicKVS.allKeys.count > 0) {
                    NSString *key = [dicKVS.allKeys firstObject];
                    [newDicKVS setObject:arrCount forKey:key];
                }
                [dicJson setObject:newDicKVS forKey:@"kvs"];
                
                // Update model
                jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:0 error:&error];
                if (error == nil) {
                    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [resultNewMetricsElement addObject:result];
                } else {
                    [resultNewMetricsElement addObject:jsonKey];
                }
            } else {
                [resultNewMetricsElement addObject:jsonKey];
            }
        } else {    // 个数为1的，无需重新调整格式
            [resultNewMetricsElement addObject:jsonKey];
        }
    }
    
    return resultNewMetricsElement;
}

@end
