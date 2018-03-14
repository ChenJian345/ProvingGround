//
//  PDFViewController.m
//  UITest
//
//  Created by Mark on 2018/3/14.
//  Copyright © 2018年 markcj. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()

@property (nonatomic, strong) UIWebView *webViewPDFViewer;

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PDF Viewer";
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

@end
