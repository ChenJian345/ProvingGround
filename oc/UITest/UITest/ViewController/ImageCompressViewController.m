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
    self.view.backgroundColor = [UIColor blueColor];
    
    NSString *imgFilePath = [[NSBundle mainBundle] pathForResource:@"IMG_3964" ofType:@"JPG"];
    UIImage *imgToCompress = [UIImage imageWithContentsOfFile:imgFilePath];
    
    self.ivToCompress = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 300)];
    self.ivToCompress.image = imgToCompress;
    [self.view addSubview:self.ivToCompress];
    
    self.ivAfterCompress = [[UIImageView alloc] initWithFrame:CGRectMake(10, 380, SCREEN_WIDTH-20, 300)];
    [self.view addSubview:self.ivAfterCompress];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Compress Image
    NSString *imgFilePath = [[NSBundle mainBundle] pathForResource:@"IMG_3964" ofType:@"JPG"];
    NSData *imgDataToCompress = [NSData dataWithContentsOfFile:imgFilePath];
    
    UIImage *imgToCompress = [UIImage imageWithData:imgDataToCompress];
    
    UIImage *imgAfterCompress = [self compress:imgToCompress limitSizeInKB:300];
    self.ivAfterCompress.image = imgAfterCompress;
    
    NSString *filePath = [self getCompressedImageFilePath];
    NSData *dataAfterCompress = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"原始文件大小：%lu KB, After compress file size : %lu KB", imgDataToCompress.length/1024, dataAfterCompress.length/1024);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Image Compress Method
- (UIImage *)compress:(UIImage *)image limitSizeInKB:(int)limitInKB {
    UIImage *imgAfterCompress = nil;
    CGFloat compression = 0.7f;
    CGFloat maxCompression = 0.1f;
    long long maxFileSize = limitInKB*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
        
        // 压缩后的文件大小
        NSLog(@"====== Image File Size : %lu KB", imageData.length/1024);
    }
    
    // 写入文件
    if ([self writeToFile:imageData]) {
        NSLog(@"写入文件成功");
    } else {
        NSLog(@"写入文件失败");
    }
    imgAfterCompress = [UIImage imageWithData:imageData];
    
    return imgAfterCompress;
}


/**
 将文件写入系统Document目录，当前是写入JPEG图片文件

 @param imgDataToSave 需要写入的图片文件
 @return 是否写入成功
 */
- (BOOL)writeToFile:(NSData *)imgDataToSave {
    if (imgDataToSave == nil) {
        return NO;
    }
    
    NSString *filePath = [self getCompressedImageFilePath];
    NSLog(@"=== Document Directory is %@", filePath);
    return [imgDataToSave writeToFile:filePath atomically:YES];
}

- (NSString *)getCompressedImageFilePath {
    // Create Directory
    NSArray *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[documentDirectory objectAtIndex:0] stringByAppendingString:@"img_after_compress.jpg"];
}

@end
