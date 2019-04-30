//
//  ViewController.m
//  UITest
//
//  Created by markcj on 13/09/2017.
//  Copyright © 2017 markcj. All rights reserved.
//

#import "ViewController.h"
#import "PaperModel.h"
#import "A4PaperModel.h"
#import "CustomView.h"

#import "BallPulseLoadingView.h"

#import "AnimationViewController.h"
#import "ImageCompressViewController.h"
#import "AlgorithmViewController.h"
#import "UIViewAnimationTestViewController.h"
#import "CollectionViewAnimationViewController.h"
#import "PDFWebViewViewController.h"
#import "PDFQLPreviewController.h"

// JSON Merge Test
#import "JSONMergeUtil.h"

static void *paperKVOContext = &paperKVOContext;

@interface ViewController ()

@property (nonatomic, strong) A4PaperModel *a4Pager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test List";
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor greenColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor redColor];
    self.tableView.tableFooterView = footerView;
    
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
//    view.backgroundColor = [UIColor greenColor];
//    view.userInteractionEnabled = YES;
//    [self.view addSubview:view];
//
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, -50, 100, 100)];
//    imgView.backgroundColor = [UIColor blueColor];
//    imgView.userInteractionEnabled = YES;
//    [view addSubview:imgView];
//
//    UITapGestureRecognizer *imgTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseToImageTap)];
//    [imgView addGestureRecognizer:imgTapGR];
//
//    CustomView *cView = [[CustomView alloc] init];
//    cView.frame = CGRectMake(0, 0, 50, 50);
//    cView.backgroundColor = [UIColor orangeColor];
//    [view addSubview:cView];
    
//    PaperModel * receiver = nil;
//    [receiver copy];
    
//    NSString *str = [NSString stringWithFormat:@"I am a String"];
//    NSLog(@"retain count = %ld", CFGetRetainCount((__bridge CFTypeRef)([NSString stringWithFormat:@"I am a String"])));
//
//    self.a4Pager = [[A4PaperModel alloc] init];
//    [self.a4Pager printSuperClassName];
//    NSLog(@"!!!Super class = %@", [self.a4Pager superclass]);
//
//    // --------- TEST KVO
//    [self.a4Pager addObserver:self forKeyPath:@"paperName" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:paperKVOContext];
    
//    NSLog(@"### Current KVO class is %@", class_ge)
    
    // --------- TEST SUPER CLASS AND CLASS NAME
//    [a4Pager printClassName];
//    [a4Pager printSuperClassName];
//    NSLog(@"A4 Size : %@", [a4Pager class]);
//    NSLog(@"A4 Paper super class : %@", [a4Pager superclass]);
//
//    NSLog(@"Super class name : %@", [a4Pager superclass]);
    
    // --------- Test GCD Async and Sync
//    NSLog(@"1"); // 任务1
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"2"); // 任务2
//    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    int numbers[] = {3,6,15,24};
//    int target = 18;
//    int size = 4;
//    int resultLength = removeElement(numbers, size, target);
//    NSLog(@"result array length = %d", resultLength);
//
//    target = 25;
//    int insertPosition = searchInsert(numbers, size, target);
//    NSLog(@"Insert position is %d", insertPosition);
}

-(void)dealloc {
    [self.a4Pager removeObserver:self forKeyPath:@"paperName"];
    self.a4Pager = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)responseToImageTap {
    NSLog(@"Click the Image");
    self.a4Pager.paperName = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];

    NSLog(@"Current Paper name is %@", self.a4Pager.paperName);
}

// TEST KVO.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"paperName"]) {
        NSString *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"Old Value: %@, New value : %@", oldValue, newValue);
    }
}

///////////////////////////////////////////////////
// 算法题目
///////////////////////////////////////////////////
int removeElement(int* nums, int numsSize, int val) {
//    int headIdx = 0;
//    int tailIdx = numsSize-1;
//    int newLength = 0;
//    if (numsSize > 0) {
//        if (numsSize == 1) {
//            return (nums[0] == val) ? 0 : 1;
//        }
//
//        while(tailIdx >= 0 && headIdx <= tailIdx) {
//            if (nums[tailIdx] == val) {
//                tailIdx--;
//                newLength++;
//                continue;
//            }
//
//            if (nums[headIdx] == val) {
//                nums[headIdx] = nums[tailIdx];
//                nums[tailIdx] = val;
//                tailIdx--;
//                newLength++;
//
//            }
//            headIdx++;
//        }
//        return numsSize - newLength;
//    } else {
//        return 0;
//    }
    
    int m = 0;
    for (int i = 0; i<numsSize; i++) {
        if (nums[i] != val) {
            nums[m] = nums[i];
            m++;
        }
    }
    
    return m;
}


int searchInsert(int* nums, int numsSize, int target) {
    int position = 0;
    for (int i = 0; i < numsSize; i++) {
        if (target > nums[i]) {
            position++;
        } else if (target == nums[i]) {
            position = i;
        } else {
            break;
        }
    }
    
    return position;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:     // Image Compress
        {
            [self.navigationController pushViewController:[[ImageCompressViewController alloc] init] animated:YES];
        }
            break;
            
            case 1:         // Animation View
        {
            [self.navigationController pushViewController:[[AnimationViewController alloc] init] animated:YES];
        }
            break;
            
            case 2:         // Algorithm
        {
            [self.navigationController pushViewController:[[AlgorithmViewController alloc] init] animated:YES];
        }
            break;
            
            case 3:         // UI Animation
        {
            [self.navigationController pushViewController:[[UIViewAnimationTestViewController alloc] init] animated:YES];
        }
            break;
            
            case 4:         // Collection View keyframe animation
        {
            [self.navigationController pushViewController:[[CollectionViewAnimationViewController alloc] init] animated:YES];
        }
            break;
            
            case 5:         // PDF WebView
        {
            PDFWebViewViewController *pdfViewController = [[PDFWebViewViewController alloc] init];
            [self.navigationController pushViewController:pdfViewController animated:YES];
        }
            break;
            
            case 6:         // PDF Quick look view
        {
            PDFQLPreviewController *pdfViewController = [[PDFQLPreviewController alloc] init];
            [self.navigationController pushViewController:pdfViewController animated:YES];
        }
            break;
            
            case 7:         // JSON Merge time usage test
        {
            // 测试JSON Merge数据
            JSONMergeUtil *jsonUtil = [[JSONMergeUtil alloc] init];
            NSArray *arrJsonStrings = [jsonUtil produceJsonStringArray];
            
            NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
            NSArray *arrJsonStrAfterMerge = [jsonUtil mergeJSONString:arrJsonStrings];
            NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
            NSLog(@"Merge JSON 操作耗时: %.2f ms", (endTime - startTime) * 1000);
            NSLog(@"处理前：%ld 条，处理后的数据条数：%ld 条", arrJsonStrings.count, arrJsonStrAfterMerge.count);
        }
            break;
            
        default:
            break;
    }
}


@end
