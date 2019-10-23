//
//  BleInfoViewController.m
//  ProvingGround
//
//  Created by Mark on 2019/10/16.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "BleInfoViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

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
    
    self.targetName = @"DDBG";
    
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
        NSLog(@"BLE - Ready, start scan!");
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
    
    if (localName != nil && localName.length > 0) {
        NSLog(@"找到设备 : %@", localName);
        if ([localName hasPrefix:self.targetName]) {
            NSString *macAddress = nil;     // Mac地址作为设备区分ID，这不合理，但硬件同事说无法用UUID写入广播的ManufacturerData, ...
            if (arrServices.count > 0) {
                CBUUID *service = arrServices.firstObject;
                NSString *strUuid = service.UUIDString;
                if (strUuid.length >= 12) {
                    macAddress = [strUuid substringFromIndex:strUuid.length-12];
                    // 转换为用英文冒号分隔的字符串
                    NSMutableString *insertedMutableString = [NSMutableString string];
                    NSUInteger i = 0;
                    while (i + 2 < macAddress.length) {
                        [insertedMutableString appendString:[macAddress substringWithRange:NSMakeRange(i, 2)]];
                        [insertedMutableString appendString:@":"];
                        i += 2;
                    }
                    [insertedMutableString appendString:[macAddress substringWithRange:NSMakeRange(i, macAddress.length - i)]];
                    macAddress = [insertedMutableString copy];
                }
            }
            
            NSString *str = [[NSString alloc] initWithFormat:@"BLE - NAME = %@, RSSI = %d, ADV Data = %@", localName, RSSI.intValue, advertisementData];
            [self appendToConsole:str];
            NSLog(@"%@", str);
        }
    }
}


@end
