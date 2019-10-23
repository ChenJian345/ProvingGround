//
//  AITensorFlowMainViewController.m
//  ProvingGround
//
//  Created by Mark on 2019/10/12.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "AITensorFlowMainViewController.h"

@interface AITensorFlowMainViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIColor *realColor;
@property (nonatomic, strong) UIFont *boldFont;

@end

@implementation AITensorFlowMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AI TensorFlow";
    // Do any additional setup after loading the view from its nib.
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 40)];
    [self.view addSubview:self.label];
    self.label.text = @"AAA";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self makeStandBlackColor];
    [self makeLabel:self.label forHtml:@"<html><body><p>这是一个段落</p></body></html>"];
}


#pragma mark - UILabel测试，无聊的测试，可以删掉的
- (void)makeStandBlackColor {
    NSError * error = nil ;
    NSMutableAttributedString* htmlStr;
    NSData* data = [@"<b>BLACK</b>" dataUsingEncoding:NSUnicodeStringEncoding];
    htmlStr = [[NSMutableAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}documentAttributes:nil error:&error];
    UIColor *realColor = nil;
    UIFont *boldFont = nil;
    if (error) {
        realColor = [UIColor blackColor];
        boldFont = [UIFont boldSystemFontOfSize:13];
    } else {
        realColor = [htmlStr attribute:NSForegroundColorAttributeName atIndex:1 effectiveRange:nil];
        boldFont = [htmlStr attribute:NSFontAttributeName atIndex:1 effectiveRange:nil];
    }
}

- (void)makeLabel:(UILabel*)label forHtml:(NSString*)string {
    if (string.length == 0) {
        return;
    }
    NSError * error = nil ;
    NSMutableAttributedString* htmlStr;
    NSData* data = [string dataUsingEncoding:NSUnicodeStringEncoding];
    
    htmlStr = [[NSMutableAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}documentAttributes:nil error:&error];
    
    if(!error){
        for (int i=0; i<htmlStr.length; i++) {
            UIFont* newft;
            if (label == self.label) {
                newft = [UIFont boldSystemFontOfSize:20];
            }else{
                UIFont* ft =  [htmlStr attribute:NSFontAttributeName atIndex:i effectiveRange:nil];
                newft = [ft.fontName isEqualToString:self.boldFont.fontName]?[UIFont boldSystemFontOfSize:13]:[UIFont systemFontOfSize:13];
            }
            [htmlStr addAttribute:NSFontAttributeName value:newft range:NSMakeRange(i, 1)];
            
            UIColor* c = [htmlStr attribute:NSForegroundColorAttributeName atIndex:i effectiveRange:nil];
            if (CGColorEqualToColor(c.CGColor, self.realColor.CGColor)) {
                if (label == self.label) {
                    [htmlStr addAttribute:NSForegroundColorAttributeName value:[self makeColor:0x999999] range:NSMakeRange(i, 1)];
                }else{
                    [htmlStr addAttribute:NSForegroundColorAttributeName value:[self makeColor:0x333333] range:NSMakeRange(i, 1)];
                }
            }
        }
        label.attributedText = htmlStr;
    }
}

- (UIColor *)makeColor:(uint32_t)rgb {
    CGFloat red = ((rgb & 0xFF0000) >> 16) / 255.0f;
    CGFloat green = ((rgb & 0x00FF00) >> 8) / 255.0f;
    CGFloat blue = (rgb & 0x0000FF) / 255.0f;
    return [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0f];
}


@end
