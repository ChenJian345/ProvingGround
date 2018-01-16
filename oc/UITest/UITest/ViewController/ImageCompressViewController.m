//
//  ImageCompressViewController.m
//  UITest
//
//  Created by Mark on 2018/1/12.
//  Copyright © 2018年 markcj. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "ImageCompressViewController.h"

@interface ImageCompressViewController ()

@property (nonatomic, strong) UIImageView *ivToCompress;
@property (nonatomic, strong) UIImageView *ivAfterCompress;

@end

@implementation ImageCompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Image Compress";
    
    UIImage *imgToCompress = [UIImage imageNamed:@"image_demo"];
    self.ivToCompress = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 300)];
    self.ivToCompress.image = imgToCompress;
    [self.view addSubview:self.ivToCompress];
    
    self.ivAfterCompress = [[UIImageView alloc] initWithFrame:CGRectMake(0, 380, SCREEN_WIDTH, 300)];
    self.ivAfterCompress.image = imgToCompress;
    [self.view addSubview:self.ivAfterCompress];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Compress Image
    UIImage *imgToCompress = [UIImage imageNamed:@"image_demo"];
    UIImage *imgAfterCompress = [self compress:imgToCompress limitSizeInKB:200];
    self.ivToCompress.image = imgAfterCompress;
    
    NSLog(@"image size Before Compress : %lu KB, After Compress : %lu KB", (UIImageJPEGRepresentation(imgToCompress, 1.0).length/1024), (UIImageJPEGRepresentation(imgAfterCompress, 0).length/1024));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Image Compress Method
- (UIImage *)compress:(UIImage *)image limitSizeInKB:(int)limitInKB {
    UIImage *imgAfterCompress = nil;
    CGFloat compression = 0.7f;
    CGFloat maxCompression = 0.01f;
    int maxFileSize = limitInKB*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    imgAfterCompress = [UIImage imageWithData:imageData];
    self.ivAfterCompress.image = imgAfterCompress;
    
    return imgAfterCompress;
}

@end
