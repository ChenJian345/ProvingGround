//
//  PDFViewController.m
//  UITest
//
//  Created by Mark on 2018/3/14.
//  Copyright © 2018年 markcj. All rights reserved.
//

#import "PDFWebViewViewController.h"
#import "Micros.h"

#define PDF_FILE_URL                @"https://www.silvair.com/whitepapers/how-to-build-a-wireless-sensor-driven-lighting-control-system-based-on-bluetooth-mesh-networking-by-silvair.pdf"

@interface PDFWebViewViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webViewPDFViewer;

@end



@implementation PDFWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PDF Viewer";
    
    // View using UIWebView
    [self setupWebView];
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

- (void)setupWebView {
    if (self.webViewPDFViewer == nil) {
        self.webViewPDFViewer = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_AND_STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_AND_STATUS_BAR_HEIGHT)];
        self.webViewPDFViewer.delegate = self;
        [self.view addSubview:self.webViewPDFViewer];
        
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:PDF_FILE_URL]];
        [self.webViewPDFViewer loadRequest:urlRequest];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"WebView start load... 🚀");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"WebView load FINISHED! 🏆");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"WebView load FAILED! 🎯");
}

@end
