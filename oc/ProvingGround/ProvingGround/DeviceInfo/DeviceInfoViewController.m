//
//  DeviceInfoViewController.m
//  ProvingGround
//
//  Created by Mark on 2019/7/19.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "DeviceInfoModel.h"

NSString * const kTableViewCellIdentifier = @"device-info-tableviewcell-identifier_%ld_%ld";
//NSString * const kTableViewCellIdentifier = @"device-info-tableviewcell-identifier";

NSString * const kTypeGeneralDeviceInfo = @"general-device-info";
NSString * const kTypeOther = @"other-Info";

@interface DeviceInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSDictionary *dicDatasource;

// Battery
@property (nonatomic, strong) DeviceInfoModel *batteryStatusModel;
@property (nonatomic, strong) DeviceInfoModel *batteryLevelModel;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Device Information";
    
    [self setupDatasource];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self startBatteryMonitoring];
}

- (void)setupDatasource {
    [self createBatteryModel];
    self.dicDatasource = @{
                           @"General Device Info" : [DeviceInfoModel getGeneralDeviceInfo],
                           @"App Information" : [DeviceInfoModel getAppInfo],
                           @"Hareware Information" : [DeviceInfoModel getHardwareInfo],
                           @"Network Information" : [DeviceInfoModel getNetworkInfo],
                           @"Advertisement Information" : [DeviceInfoModel getAdvertisementInfo],
                           @"Battery Information" : [self createBatteryModel],
                           @"Disk Usage" : [DeviceInfoModel getDiskInfo],
                           @"CPU Usage" : [DeviceInfoModel getCPUInfo],
                           @"Memory Usage" : [DeviceInfoModel getMemoryInfo],
                           };
}

- (void)dealloc {
    [self stopBatteryMonitoring];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dicDatasource.allKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dicDatasource.allKeys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arrCurrentSection = [self.dicDatasource.allValues objectAtIndex:section];
    return arrCurrentSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:kTableViewCellIdentifier, indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    NSString *key = [self.dicDatasource.allKeys objectAtIndex:indexPath.section];
    NSArray *models = [self.dicDatasource objectForKey:key];
    DeviceInfoModel *model = models[indexPath.row];
    if (model) {
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = model.value;
    }
    
    return cell;
}

#pragma mark - 电池信息
- (void)startBatteryMonitoring {
    UIDevice *device = [UIDevice currentDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBatteryLevelUpdate:)
                                                 name:UIDeviceBatteryLevelDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBatteryStatusUpdate:)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];
    
    [device setBatteryMonitoringEnabled:YES];
    
    // If by any chance battery value is available - update it immediately
    if ([device batteryState] != UIDeviceBatteryStateUnknown) {
        
    }
}

- (void)stopBatteryMonitoring {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)createBatteryModel {
    UIDevice *device = [UIDevice currentDevice];
    if (!self.batteryStatusModel) {
        self.batteryStatusModel = [[DeviceInfoModel alloc] init];
        self.batteryStatusModel.name = @"Battery Status";
        switch (device.batteryState) {
            case UIDeviceBatteryStateFull:
            {
                self.batteryStatusModel.value = @"Full";
            }
                break;
                
            case UIDeviceBatteryStateUnknown:
            {
                self.batteryStatusModel.value = @"Unknown";
            }
                break;
                
            case UIDeviceBatteryStateCharging:
            {
                self.batteryStatusModel.value = @"Charging";
            }
                break;
                
            case UIDeviceBatteryStateUnplugged:
            {
                self.batteryStatusModel.value = @"Unplugged";
            }
                break;
                
            default:
                break;
        }
    }
    
    if (!self.batteryLevelModel) {
        self.batteryLevelModel = [[DeviceInfoModel alloc] init];
        self.batteryLevelModel.name = @"Battery Level";
        if (device.batteryLevel >= 0) {
            self.batteryLevelModel.value = [NSString stringWithFormat:@"%d %%", (int)(device.batteryLevel*100)];
        } else {
            self.batteryLevelModel.value = @"Unknown";
        }
    }
    
    return @[self.batteryStatusModel, self.batteryLevelModel];
}

- (void)didBatteryStatusUpdate:(NSNotification *)notification {
    NSLog(@"电池状态更新： %@", notification);
    [self updateBatteryValue];
    [self.tableview reloadData];
}

- (void)didBatteryLevelUpdate:(NSNotification *)notification {
    NSLog(@"电池电量更新：%@", notification);
    [self updateBatteryValue];
    [self.tableview reloadData];
}

- (void)updateBatteryValue {
    UIDevice *device = [UIDevice currentDevice];
    switch (device.batteryState) {
        case UIDeviceBatteryStateFull:
        {
            self.batteryStatusModel.value = @"Full";
        }
            break;
            
        case UIDeviceBatteryStateUnknown:
        {
            self.batteryStatusModel.value = @"Unknown";
        }
            break;
            
        case UIDeviceBatteryStateCharging:
        {
            self.batteryStatusModel.value = @"Charging";
        }
            break;
            
        case UIDeviceBatteryStateUnplugged:
        {
            self.batteryStatusModel.value = @"Unplugged";
        }
            break;
            
        default:
            break;
    }
    
    if (device.batteryLevel >= 0) {
        self.batteryLevelModel.value = [NSString stringWithFormat:@"%d%%", (int)(device.batteryLevel*100)];
    } else {
        self.batteryLevelModel.value = @"Unknown";
    }
}

@end
