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

#define IMAGE_FILE_NAME         @"IMG_0397"
#define IMAGE_FILE_SUFFIX       @"JPG"

@interface ImageCompressViewController ()

@property (nonatomic, strong) UIImageView *ivToCompress;
@property (nonatomic, strong) UIImageView *ivAfterCompress;

@property (nonatomic, strong) NSData *imgDataToCompress;
@property (nonatomic, strong) UIImage *imgFileToCompress;

@end

@implementation ImageCompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Image Compress";
    self.view.backgroundColor = [UIColor blueColor];

    // Init Data
    if (self.imgFileToCompress == nil) {
        NSString *imgFilePath = [[NSBundle mainBundle] pathForResource:IMAGE_FILE_NAME ofType:IMAGE_FILE_SUFFIX];
        self.imgDataToCompress = [NSData dataWithContentsOfFile:imgFilePath];
        self.imgFileToCompress = [UIImage imageWithContentsOfFile:imgFilePath];
    }
    
    // Init UI
    self.ivToCompress = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 300)];
    self.ivToCompress.image = self.imgFileToCompress;
    [self.view addSubview:self.ivToCompress];
    
    self.ivAfterCompress = [[UIImageView alloc] initWithFrame:CGRectMake(10, 380, SCREEN_WIDTH-20, 300)];
    [self.view addSubview:self.ivAfterCompress];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Compress Image
    UIImage *imgAfterCompress = [self compress:self.imgFileToCompress limitSizeInKB:300];
    self.ivAfterCompress.image = imgAfterCompress;
    
    NSString *filePath = [self getCompressedImageFilePath];
    NSData *dataAfterCompress = [NSData dataWithContentsOfFile:filePath];
    
    NSLog(@"Original File ：%lu KB, After compress : %lu KB",  self.imgDataToCompress.length/1024, dataAfterCompress.length/1024);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Image Compress Method
- (UIImage *)compress:(UIImage *)image limitSizeInKB:(int)limitInKB {
    UIImage *imgAfterCompress = nil;
    CGFloat compression = 0.7f;
    CGFloat maxCompression = 0.01f;
    long long maxFileSize = limitInKB*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);

        NSLog(@"====== Image File Size : %lu KB, compression = %.2f", imageData.length/1024, compression);
    }
    
    // Save to file
    if ([self writeToFile:imageData]) {
        NSLog(@"Save Successed");
    } else {
        NSLog(@"Save Failed");
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


/**
 Get compressed image file path.

 @return BOOL
 */
- (NSString *)getCompressedImageFilePath {
    // Create Directory
    NSArray *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[documentDirectory objectAtIndex:0] stringByAppendingString:@"img_after_compress.jpg"];
}

@end
