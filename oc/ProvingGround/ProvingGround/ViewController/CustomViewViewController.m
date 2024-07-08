//
//  CustomViewViewController.m
//  UITest
//
//  Created by Mark on 2018/1/16.
//  Copyright © 2018年 markcj. All rights reserved.
//

#import "CustomViewViewController.h"

#import <CoreText/CoreText.h>

@interface CustomViewViewController ()

@property (nonatomic, strong) UILabel *lblVoiceContent;

@end

@implementation CustomViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// 工具方法
- (long)truncate:(NSString *)text font:(UIFont *)font {
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    NSDictionary *attr = [NSDictionary dictionaryWithObject:(__bridge id)ctFont forKey:(id)kCTFontAttributeName];
    NSAttributedString *attrString  = [[NSAttributedString alloc] initWithString:text attributes:attr];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString ((__bridge CFAttributedStringRef) attrString);;
    CFRange fitRange;
    CTFramesetterSuggestFrameSizeWithConstraints(frameSetter,
                                                 CFRangeMake(0, 0),
                                                 NULL,
                                                 CGSizeMake(self.lblVoiceContent.bounds.size.width, self.lblVoiceContent.bounds.size.height),
                                                 &fitRange);
    CFRelease(ctFont);
    CFRelease(frameSetter);
    return fitRange.length;
}

@end
