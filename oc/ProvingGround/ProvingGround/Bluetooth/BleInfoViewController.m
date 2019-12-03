//
//  BleInfoViewController.m
//  ProvingGround
//
//  Created by Mark on 2019/10/16.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "BleInfoViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CommonCrypto/CommonCrypto.h>

#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */

@interface BleInfoViewController () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, assign) BOOL scanning;      // 是否正在扫描

@property (nonatomic, strong) NSString *targetName; // 目标名称
@property (weak, nonatomic) IBOutlet UITextView *tvConsole;

@end

@implementation BleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bluetooth Info";
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonClicked)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIGestureRecognizer *tapReg = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapReg];
    
    self.targetName = nil;
    
    // Scan device in the main thread
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:[NSDictionary dictionaryWithObject:@YES forKey:CBCentralManagerOptionShowPowerAlertKey]];
    self.scanning = NO;
}

#pragma mark - Event Handler
- (void)onButtonClicked {
    if (!self.scanning) {
        [self startScan];
        
        [self.navigationItem.rightBarButtonItem setTitle:@"Stop"];
    } else {
        [self stopScan];
        [self.navigationItem.rightBarButtonItem setTitle:@"Start"];
    }
}
- (IBAction)targetEditingDidEnd:(UITextField *)sender {
    if (sender.text.length > 0) {
        self.targetName = sender.text;
    }
}

- (void)appendToConsole:(NSString *)newText {
    if (newText.length <= 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *oldText = self.tvConsole.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        NSString *time = [formatter stringFromDate:[NSDate date]];
        
        if (oldText.length <= 0) {
            weakSelf.tvConsole.text = [NSString stringWithFormat:@"%@=> %@", time, newText];
        } else {
            weakSelf.tvConsole.text = [NSString stringWithFormat:@"%@\n%@=> %@", oldText, time, newText];
        }
        
        
        NSRange bottom = NSMakeRange(weakSelf.tvConsole.text.length -1, 1);
        [weakSelf.tvConsole scrollRangeToVisible:bottom];
    });
}

#pragma mark - Ble Scan

/**
 Start ble scan
 */
- (void)startScan {
    NSLog(@"=============== BLE - Start Scan BLE Device ===============");
    if (self.centralManager.state == CBCentralManagerStatePoweredOn && !self.scanning){
        [self scanDevices];
    } else {
        NSLog(@"BLE - NOT Ready.");
    }
}

/**
 Stop BLE scan
 */
- (void)stopScan {
    NSLog(@"=============== BLE - Stop Scan BLE Device ===============");
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager stopScan];
        self.scanning = NO;
    }
}

- (void)scanDevices {
    if (self.centralManager != nil) {
        NSLog(@"BLE - 开始扫描设备: %@", self.targetName);
        [self.centralManager scanForPeripheralsWithServices:nil
                                                    options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
        self.scanning = YES;
    }
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"BLE - [硬件到店] 当前蓝牙开关已打开");
    } else {
        self.scanning = NO;
        NSLog(@"BLE - [硬件到店] 当前蓝牙开关已关闭，state = %ld", (long)central.state);
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    NSArray *arrServices = [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
    NSData *manufactureData = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
    if (localName != nil && localName.length > 0) {
        // 目标设备为空时，默认扫描所有所有设备
        if (!self.targetName || self.targetName.length == 0 || [localName hasPrefix:self.targetName]) {
            NSString *str = [[NSString alloc] initWithFormat:@"BLE - NAME = %@, RSSI = %d, ADV Data = %@, Services = %@, ManufactureData = %@", localName, RSSI.intValue, advertisementData, arrServices, manufactureData];
            [self appendToConsole:str];
            NSLog(@"%@", str);
        }
    }
}

- (NSData *)getEncryptKeyBySeed:(NSString *)keySeed {
    uint8_t md5[CC_MD5_DIGEST_LENGTH];
    NSData *dataKeySeed = [keySeed dataUsingEncoding:NSUTF8StringEncoding];
    CC_MD5(dataKeySeed.bytes, (CC_LONG)dataKeySeed.length, md5);
    NSData *data = [NSData dataWithBytes:md5 length:CC_MD5_DIGEST_LENGTH];
    NSLog(@"BLE - MD5 KeySeed = %@, md5 = %@", keySeed, [self getHexString:data]);
    return data;
}

- (NSString *)getHexString:(NSData *)data {
    if (data.length == 0) {
        return @"";
    }
    uint8_t *byteArray = (uint8_t *)[data bytes];
    NSMutableString *strResult = [[NSMutableString alloc] init];
    for (int i = 0; i < [data length]; i++) {
        [strResult appendFormat:@"%02X", byteArray[i]];
    }
    return strResult;
}

@end
