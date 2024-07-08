//
//  CoreLocationTestViewController.m
//  ProvingGround
//
//  Created by Mark on 2019/10/23.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "CoreLocationTestViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CoreLocationTestViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLCircularRegion *monitorRegion;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPointAnnotation *myLocationAnnotation;

// Geo fense
@property (nonatomic, assign) CLLocationCoordinate2D geoFenseCenter;
@property (nonatomic, assign) NSInteger geoFenseRadiusInMeter;

@end

@implementation CoreLocationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Core Location";

    // MapView
    self.mapView.delegate = self;
    self.myLocationAnnotation = [[MKPointAnnotation alloc] init];
    [self.mapView addAnnotation:self.myLocationAnnotation];
    
    NSMutableArray *arrBoundLocations = [[NSMutableArray alloc] init];
    // 39.9269540255,116.4108353823
    CLLocation *location = [[CLLocation alloc] initWithLatitude:39.9269540255 longitude:116.4108353823];
    [arrBoundLocations addObject:location];
    
    // 39.9283298508,116.4194970219
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:39.9283298508 longitude:116.4194970219];
    [arrBoundLocations addObject:location1];
    
    // 39.9226637781,116.4251508829
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:39.9226637781 longitude:116.4251508829];
    [arrBoundLocations addObject:location2];
    
    // 39.9181939521,116.4152071475
    CLLocation *location3 = [[CLLocation alloc] initWithLatitude:39.9181939521 longitude:116.4152071475];
    [arrBoundLocations addObject:location3];
    
    // 39.9222797714,116.4042246005
    CLLocation *location4 = [[CLLocation alloc] initWithLatitude:39.9222797714 longitude:116.4042246005];
    [arrBoundLocations addObject:location4];
    
    // 内：39.9235258819,116.4215586184
    // 外：39.9019154155,116.3704627902
    //    CLLocationCoordinate2D myLocation = CLLocationCoordinate2DMake(39.9019154155, 116.3704627902);
    //    BOOL inside = [self mutableBoundConrtolAction:arrBoundLocations myLocation:myLocation];
    //    if (inside) {
    //        NSLog(@"身在其中");
    //    } else {
    //        NSLog(@"跳脱之外");
    //    }

    // 奥森-银杏林：40.0144756101,116.3856487518
    // 奥森-五环亭：40.0135889097,116.3808416300
    self.geoFenseCenter = CLLocationCoordinate2DMake(40.0135889097, 116.3808416300);
    self.geoFenseRadiusInMeter = 300;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.geoFenseCenter, span);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.geoFenseCenter;
    annotation.title = @"Beacon中心";
    annotation.subtitle = [NSString stringWithFormat:@"半径%ld米", (long)self.geoFenseRadiusInMeter];
    [self.mapView addAnnotation:annotation];
    
    MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:self.geoFenseCenter radius:self.geoFenseRadiusInMeter];
    [self.mapView addOverlay:circleOverlay];
    [self.mapView setRegion:region animated:YES];
    [self.mapView showsUserLocation];

    // 配置电子围栏部分
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestAlwaysAuthorization];
    }
    
    if (!self.monitorRegion) {
        self.monitorRegion = [[CLCircularRegion alloc] initWithCenter:self.geoFenseCenter radius:self.geoFenseRadiusInMeter identifier:@"Olympic-Forest-Park"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Geo fense
    if (self.locationManager && self.monitorRegion) {
        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringVisits];
        [self.locationManager startMonitoringForRegion:self.monitorRegion];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.locationManager stopMonitoringVisits];
    [self.locationManager stopMonitoringForRegion:self.monitorRegion];
}

- (void)dealloc {
    if (self.locationManager) {
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
    
    if (self.monitorRegion) {
        self.monitorRegion = nil;
    }
}

#pragma mark - 判断某一坐标点是否在某一区域内
//    在范围内返回1，不在返回0
-(BOOL)mutableBoundConrtolAction:(NSArray<CLLocation *> *)arrSomeCoordinates myLocation:(CLLocationCoordinate2D )myCoordinate4 {
    if (arrSomeCoordinates.count == 0) {
        return YES;
    }
    
    const unsigned long N = arrSomeCoordinates.count;
    double vertx[N];
    double verty[N];
    CLLocation *location = nil;
    for (int i = 0; i < arrSomeCoordinates.count; i++) {
        location = arrSomeCoordinates[i];
        vertx[i] = location.coordinate.latitude;
        verty[i] = location.coordinate.longitude;
    }
    
    return pnpoly(arrSomeCoordinates.count, vertx, verty, myCoordinate4.latitude, myCoordinate4.longitude);
}
//多边形由边界的坐标点所构成的数组组成，参数格式 该数组的count，  多边形边界点x坐标 的组成的数组，多边形边界点y坐标 的组成的数组，需要判断的点的x坐标，需要判断的点的y坐标
BOOL pnpoly (int nvert, float *vertx, float *verty, float testx, float testy) {
    int i, j;
    BOOL c=NO;
    for (i = 0, j = nvert-1; i < nvert; j = i++) {
        if ( ( (verty[i]>testy) != (verty[j]>testy) ) &&
            (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
            c = !c;
    }
    return c;
}

#pragma mark - 电子围栏
/**
 电子围栏功能需要用户同意"始终访问"这一项,"仅使用期间"和"拒绝访问"这两个权限都会使该功能不能达到预期的效果,会有问题.拒绝状态直接导致该功能无法使用.仅使用期间会导致App退到后台或者在控制中心手动杀掉后不能正常使用.
 
 每次使用该功能前,最好获取一下用户的权限设置,如果是拒绝状态可以提示用户,并引导跳转到权限设置界面.如果是仅使用期间状态,可以给与用户提示切换成始终访问权限.
 
 链接：https://www.jianshu.com/p/e7015207ecef
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */


/*
 *  locationManager:didUpdateLocations:
 *
 *  Discussion:
 *    Invoked when new locations are available.  Required for delivery of
 *    deferred locations.  If implemented, updates will
 *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
 *
 *    locations is an array of CLLocation objects in chronological order.
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations API_AVAILABLE(ios(6.0), macos(10.9)) {
    NSLog(@"位置更新, location count = %lu", locations.count);
    if (locations.count > 0) {
        CLLocation *location = [locations firstObject];
        self.myLocationAnnotation.coordinate = location.coordinate;
    }
}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"定位失败，error = %@", error);
}

/*
 *  locationManager:didDetermineState:forRegion:
 *
 *  Discussion:
 *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
 *    a call to requestStateForRegion:.
 */
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSString *str = nil;
    switch (state) {
        case CLRegionStateInside:
        {
        str = @"Inside";
        }
            break;
            
        case CLRegionStateOutside:
        {
        str = @"Outside";
        }
            break;
            
        case CLRegionStateUnknown:
        {
        str = @"Unknown";
        }
            break;
    }
    NSLog(@"检查当前位置与区域关系： %@", str);
}

/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region API_AVAILABLE(ios(4.0), macos(10.8)) API_UNAVAILABLE(watchos, tvos) {
    NSLog(@"进入电子围栏（%@）", region.identifier);
}

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region API_AVAILABLE(ios(4.0), macos(10.8)) API_UNAVAILABLE(watchos, tvos) {
    NSLog(@"离开电子围栏（%@）", region.identifier);
}

/*
 *  locationManager:monitoringDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(nullable CLRegion *)region
              withError:(NSError *)error API_AVAILABLE(ios(4.0), macos(10.8)) API_UNAVAILABLE(watchos, tvos) {
    NSLog(@"监听电子围栏失败，error = %@", error.localizedDescription);
}

/*
 *  locationManager:didChangeAuthorizationStatus:
 *
 *  Discussion:
 *    Invoked when the authorization status changes for this application.
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status API_AVAILABLE(ios(4.2), macos(10.7)) {
    NSLog(@"定位授权变更，new state = %d", status);
}

/*
 *  locationManager:didStartMonitoringForRegion:
 *
 *  Discussion:
 *    Invoked when a monitoring for a region started successfully.
 */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region API_AVAILABLE(ios(5.0), macos(10.8)) API_UNAVAILABLE(watchos, tvos) {
    NSLog(@"开始监控电子围栏");
}

/*
 *  locationManager:didVisit:
 *
 *  Discussion:
 *    Invoked when the CLLocationManager determines that the device has visited
 *    a location, if visit monitoring is currently started (possibly from a
 *    prior launch).
 */
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit API_AVAILABLE(ios(8.0)) API_UNAVAILABLE(watchos, tvos, macos) {
    
}

#pragma mark - MapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor systemPinkColor];
        circleView.fillColor = [UIColor systemPinkColor];
        circleView.alpha = 0.5;
        return circleView;
    }
    return nil;
}

@end
