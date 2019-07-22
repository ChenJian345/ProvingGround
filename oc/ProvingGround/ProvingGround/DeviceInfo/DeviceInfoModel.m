//
//  DeviceInfoModel.m
//  ProvingGround
//
//  Created by Mark on 2019/7/19.
//  Copyright © 2019 markcj. All rights reserved.
//

#import "DeviceInfoModel.h"

#import <UIKit/UIKit.h>
#import "sys/utsname.h"

// Mac Address
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>

// IP Address
#include <ifaddrs.h>

// CPU Info
#include <mach/mach.h>

// IDFA
#import <AdSupport/AdSupport.h>

@implementation DeviceInfoModel

- (instancetype)initWithName:(NSString *)name value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.name = name;
        self.value = value;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name = %@, value = %@", self.name, self.value];
}

#pragma mark - 获取一般设备信息
+ (NSArray *)getGeneralDeviceInfo {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    UIDevice *device = [UIDevice currentDevice];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"iPhone Name" value:device.name]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Device Model" value:device.model]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Localized Model" value:device.localizedModel]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"System Name" value:device.systemName]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"System Version" value:device.systemVersion]];
    
    return mutArray;
}

+ (NSString *)getDeviceModel {
    static NSDictionary *platformMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        platformMap = @{
                        // @see http://theiphonewiki.com/wiki/Models
                        // iPhone
                        @"iPhone1,1" : @"iPhone 1G",
                        @"iPhone1,2" : @"iPhone 3G",
                        @"iPhone2,1" : @"iPhone 3GS",
                        @"iPhone3,1" : @"iPhone 4 (GSM)",
                        @"iPhone3,2" : @"iPhone 4 (GSM Rev A)",
                        @"iPhone3,3" : @"iPhone 4 (CDMA)",
                        @"iPhone4,1" : @"iPhone 4S",
                        @"iPhone5,1" : @"iPhone 5 (GSM)",
                        @"iPhone5,2" : @"iPhone 5 (CDMA)",
                        @"iPhone5,3" : @"iPhone 5c (GSM)",
                        @"iPhone5,4" : @"iPhone 5c (Global)",
                        @"iPhone6,1" : @"iPhone 5s (GSM+CDMA)",
                        @"iPhone6,2" : @"iPhone 5s (Global)",
                        @"iPhone7,1" : @"iPhone 6 Plus",
                        @"iPhone7,2" : @"iPhone 6",
                        @"iPhone8,1" : @"iPhone 6s",
                        @"iPhone8,2" : @"iPhone 6s Plus",
                        @"iPhone8,4" : @"iPhone SE",
                        @"iPhone9,1" : @"iPhone 7",
                        @"iPhone9,3" : @"iPhone 7",
                        @"iPhone9,2" : @"iPhone 7 Plus",
                        @"iPhone9,4" : @"iPhone 7 Plus",
                        @"iPhone10,1" : @"iPhone 8",
                        @"iPhone10,4" : @"iPhone 8",
                        @"iPhone10,2" : @"iPhone 8 Plus",
                        @"iPhone10,5" : @"iPhone 8 Plus",
                        @"iPhone10,3" : @"iPhone X",
                        @"iPhone10,6" : @"iPhone X",
                        @"iPhone11,2" : @"iPhone XS",
                        @"iPhone11,4" : @"iPhone XS Max",
                        @"iPhone11,6" : @"iPhone XS Max",
                        @"iPhone11,8" : @"iPhone XR",
                        
                        // iPod
                        @"iPod1,1" : @"iPod Touch 1G",
                        @"iPod2,1" : @"iPod Touch 2G",
                        @"iPod3,1" : @"iPod Touch 3G",
                        @"iPod4,1" : @"iPod Touch 4G",
                        @"iPod5,1" : @"iPod Touch 5G",
                        @"iPod7,1" : @"iPod Touch 6G",
                        
                        // iPad
                        @"iPad1,1" : @"iPad",
                        @"iPad2,1" : @"iPad 2 (WiFi)",
                        @"iPad2,2" : @"iPad 2 (GSM)",
                        @"iPad2,3" : @"iPad 2 (CDMA)",
                        @"iPad2,4" : @"iPad 2 (WiFi Rev A)",
                        @"iPad3,1" : @"iPad 3 (WiFi)",
                        @"iPad3,2" : @"iPad 3 (GSM+CDMA)",
                        @"iPad3,3" : @"iPad 3 (GSM)",
                        @"iPad3,4" : @"iPad 4 (WiFi)",
                        @"iPad3,5" : @"iPad 4 (GSM)",
                        @"iPad3,6" : @"iPad 4 (GSM+CDMA)",
                        @"iPad4,1" : @"iPad Air (WiFi)",
                        @"iPad4,2" : @"iPad Air (Cellular)",
                        @"iPad4,3" : @"iPad Air (Cellular)",
                        @"iPad5,3" : @"iPad Air2",
                        @"iPad5,4" : @"iPad Air2",
                        @"iPad6,3" : @"iPad Pro (9.7 inch)",
                        @"iPad6,4" : @"iPad Pro (9.7 inch)",
                        @"iPad6,7" : @"iPad Pro (12.9 inch)",
                        @"iPad6,8" : @"iPad Pro (12.9 inch)",
                        @"iPad6,11" : @"iPad (5th generation)",
                        @"iPad6,12" : @"iPad (5th generation)",
                        @"iPad7,1" : @"iPad Pro (12.9-inch, 2nd generation)",
                        @"iPad7,2" : @"iPad Pro (12.9-inch, 2nd generation)",
                        @"iPad7,3" : @"iPad Pro (10.5-inch)",
                        @"iPad7,4" : @"iPad Pro (10.5-inch)",
                        
                        // iPad Mini
                        @"iPad2,5" : @"iPad Mini (WiFi)",
                        @"iPad2,6" : @"iPad Mini (GSM)",
                        @"iPad2,7" : @"iPad Mini (GSM+CDMA)",
                        @"iPad4,4" : @"iPad Mini2 (WiFi)",
                        @"iPad4,5" : @"iPad Mini2 (Cellular)",
                        @"iPad4,6" : @"iPad Mini2",
                        @"iPad4,7" : @"iPad Mini3",
                        @"iPad4,8" : @"iPad Mini3",
                        @"iPad4,9" : @"iPad Mini3",
                        @"iPad5,1" : @"iPad Mini4",
                        @"iPad5,2" : @"iPad Mini4",
                        
                        // watch
                        @"Watch1,1" : @"Apple Watch",
                        @"Watch1,2" : @"Apple Watch",
                        @"Watch2,3" : @"Apple Watch Series 2",
                        @"Watch2,4" : @"Apple Watch Series 2",
                        @"Watch2,6" : @"Apple Watch Series 1",
                        @"Watch2,7" : @"Apple Watch Series 1",
                        @"Watch3,1" : @"Apple Watch Series 3",
                        @"Watch3,2" : @"Apple Watch Series 3",
                        @"Watch3,3" : @"Apple Watch Series 3",
                        @"Watch3,4" : @"Apple Watch Series 3",
                        
                        // Xcode iOS Simulator
                        @"i386" : @"iOS i386 Simulator",
                        @"x86_64" : @"iOS x86_64 Simulator"
                        };
    });
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platformMap[deviceString] ?: deviceString;
}

#pragma mark - 当前App信息
+ (NSArray *)getAppInfo {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"App Version" value:appVerion]];
    
    return mutArray;
}

#pragma mark - 硬件信息
+ (NSArray *)getHardwareInfo {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device_model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *device_nodename = [NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding];
    NSString *device_sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    NSString *device_release = [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding];
    NSString *device_version = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Hardware Type" value:device_model]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Hardware Node Name" value:device_nodename]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Hardware Sys Name" value:device_sysname]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Hardware Release" value:device_release]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Hardware Version" value:device_version]];
    
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Device Platform" value:[self getDeviceModel]]];
    
    return mutArray;
}

#pragma mark - 网络信息
+ (NSArray *)getNetworkInfo {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"IP Address" value:[self getDeviceIPAddresses]]];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"Mac Address" value:[NSString stringWithFormat:@"%@", [self getMacAddress]]]];
    
    return mutArray;
}

+ (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)getDeviceIPAddresses {
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}

#pragma mark - 广告标识符相关
+ (NSArray *)getAdvertisementInfo {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [mutArray addObject:[[DeviceInfoModel alloc] initWithName:@"IDFA" value:idfa]];
    
    return mutArray;
}

#pragma mark - 电池信息
//- (void)startBatteryMonitoring {
//    if (!self.batteryMonitoringEnabled) {
//        self.batteryMonitoringEnabled = YES;
//        UIDevice *device = [UIDevice currentDevice];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(_batteryLevelUpdatedCB:)
//                                                     name:UIDeviceBatteryLevelDidChangeNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(_batteryStatusUpdatedCB:)
//                                                     name:UIDeviceBatteryStateDidChangeNotification
//                                                   object:nil];
//
//        [device setBatteryMonitoringEnabled:YES];
//
//        // If by any chance battery value is available - update it immediately
//        if ([device batteryState] != UIDeviceBatteryStateUnknown) {
//            [self _doUpdateBatteryStatus];
//        }
//    }
//}
//
//- (void)stopBatteryMonitoring {
//    if (self.batteryMonitoringEnabled) {
//        self.batteryMonitoringEnabled = NO;
//        [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//    }
//}

@end
