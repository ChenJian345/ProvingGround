//
//  PhoneSensorViewController.m
//  ProvingGround
//
//  Created by Mark on 2020/3/11.
//  Copyright © 2020 markcj. All rights reserved.
//

#import "PhoneSensorViewController.h"

// 通过摄像头读取手机光感数据
@import AVFoundation;
#import <ImageIO/ImageIO.h>
// END, 通过摄像头读取手机光感数据

@interface PhoneSensorViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblLight;

// 通过摄像头读取手机光感数据
@property (nonatomic, strong) AVCaptureSession *avCaptureSession;

@end

@implementation PhoneSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Phone Sensor Info.";
    
    // 通过摄像头读取手机光感数据
    [self lightSensitive];
}

- (void)dealloc {
    if (self.avCaptureSession) {
        [self.avCaptureSession stopRunning];
        self.avCaptureSession = nil;
    }
}

#pragma mark - 测试光感
- (void)lightSensitive {
    // 1.获取硬件设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2.创建输入流
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    
    // 3.创建设备输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    // AVCaptureSession属性
    self.avCaptureSession = [[AVCaptureSession alloc] init];
    // 设置为高质量采集率
    [self.avCaptureSession setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加会话输入和输出
    if ([self.avCaptureSession canAddInput:input]) {
        [self.avCaptureSession addInput:input];
    }
    if ([self.avCaptureSession canAddOutput:output]) {
        [self.avCaptureSession addOutput:output];
    }
    
    // 9.启动会话
    [self.avCaptureSession startRunning];
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    // 亮度值，单位APEX
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"%f",brightnessValue);
    self.lblLight.text = [NSString stringWithFormat:@"光感值：%.2f", brightnessValue];
    
    //    // 根据brightnessValue的值来打开和关闭闪光灯
    //    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //    BOOL result = [device hasTorch];// 判断设备是否有闪光灯
    //    if ((brightnessValue < 0) && result) {// 打开闪光灯
    //        [device lockForConfiguration:nil];
    //        [device setTorchMode: AVCaptureTorchModeOn];//开
    //        [device unlockForConfiguration];
    //    } else if((brightnessValue > 0) && result) {// 关闭闪光灯
    //        [device lockForConfiguration:nil];
    //        [device setTorchMode: AVCaptureTorchModeOff];//关
    //        [device unlockForConfiguration];
    //    }
}


@end
