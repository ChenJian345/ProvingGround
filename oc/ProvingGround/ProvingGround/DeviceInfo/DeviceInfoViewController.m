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

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Device Information";
    
    [self setupDatasource];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

- (void)setupDatasource {
    self.dicDatasource = @{
                           @"General Device Info" : [DeviceInfoModel getGeneralDeviceInfo],
                           @"App Information" : [DeviceInfoModel getAppInfo],
                           @"Hareware Information" : [DeviceInfoModel getHardwareInfo],
                           @"Network Information" : [DeviceInfoModel getNetworkInfo],
                           @"Advertisement Information" : [DeviceInfoModel getAdvertisementInfo]
                           };
}

#pragma mark - UITableViewDelegate

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

@end
