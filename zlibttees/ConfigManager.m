//
//  ConfigManager.m
//  zlibttees
//
//  Created by MaMingkun on 16/12/16.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//


#import "ConfigManager.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <netdb.h>
#import <sys/utsname.h>
#include <sys/socket.h>

#include <resolv.h>
#include <dns.h>

#import <sys/sysctl.h>
#import <netinet/in.h>

#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "PPSRoute.h"
#endif /*the very same from google-code*/

#define ROUNDUP(a) ((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

@implementation ConfigManager

+(NSString *)formatIPV4Address:(struct in_addr)ipv4Addr{
    NSString *address = nil;
    
    char dstStr[INET_ADDRSTRLEN];
    char srcStr[INET_ADDRSTRLEN];
    
    memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
    
    if (inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL) {
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

+(NSString *)formatIPV6Address:(struct in6_addr)ipv6Addr{
    NSString *address = nil;
    
    char dstStr[INET6_ADDRSTRLEN];
    char srcStr[INET6_ADDRSTRLEN];
    
    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
    
    if (inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL) {
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

+(NSString *)deviceIpAddress{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        
        temp_addr = interfaces;
        
        while (temp_addr != NULL) {
            
            if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] || [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                if (temp_addr->ifa_addr->sa_family == AF_INET) {
                    
                    
                    address = [self formatIPV4Address:((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr];
                    
                }else if (temp_addr->ifa_addr->sa_family == AF_INET6) {
                    
                }
            }
            
            
            temp_addr = temp_addr->ifa_next;
            
        }
        
        
    }
    
    
    return address;
}

+(NSString *)getGatewayIPv4Address{
    NSString *address = nil;
    
    /* net.route.0.inet.flags.gateway */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_FLAGS, RTF_GATEWAY};
    
    size_t l;
    char *buf, *p;
    struct rt_msghdr *rt;
    struct sockaddr *sa;
    struct sockaddr *sa_tab[RTAX_MAX];
    int i;
    
    if (sysctl(mib, sizeof(mib) / sizeof(int), 0, &l, 0, 0) < 0) {
        address = @"192.168.0.1";
    }
    
    if (l > 0) {
        buf = malloc(l);
        if (sysctl(mib, sizeof(mib) / sizeof(int), buf, &l, 0, 0) < 0) {
            address = @"192.168.0.1";
        }
        
        for (p = buf; p < buf + l; p += rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for (i = 0; i < RTAX_MAX; i++) {
                if (rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if (((rt->rtm_addrs & (RTA_DST | RTA_GATEWAY)) == (RTA_DST | RTA_GATEWAY)) &&
                sa_tab[RTAX_DST]->sa_family == AF_INET &&
                sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                unsigned char octet[4] = {0, 0, 0, 0};
                int i;
                for (i = 0; i < 4; i++) {
                    octet[i] = (((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr >>
                                (i * 8)) &
                    0xFF;
                }
                if (((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    in_addr_t addr =
                    ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                    address = [self formatIPV4Address:*((struct in_addr *)&addr)];
                    //                    NSLog(@"IPV4address%@", address);
                    break;
                }
            }
        }
        free(buf);
    }
    
    return address;
}

+ (NSString *)getGatewayIPv6Address
{
    
    NSString *address = nil;
    
    /* net.route.0.inet.flags.gateway */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET6, NET_RT_FLAGS, RTF_GATEWAY};
    
    size_t l;
    char *buf, *p;
    struct rt_msghdr *rt;
    struct sockaddr_in6 *sa;
    struct sockaddr_in6 *sa_tab[RTAX_MAX];
    int i;
    
    if (sysctl(mib, sizeof(mib) / sizeof(int), 0, &l, 0, 0) < 0) {
        address = @"192.168.0.1";
    }
    
    if (l > 0) {
        buf = malloc(l);
        if (sysctl(mib, sizeof(mib) / sizeof(int), buf, &l, 0, 0) < 0) {
            address = @"192.168.0.1";
        }
        
        for (p = buf; p < buf + l; p += rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr_in6 *)(rt + 1);
            for (i = 0; i < RTAX_MAX; i++) {
                if (rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr_in6 *)((char *)sa + sa->sin6_len);
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if( ((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
               && sa_tab[RTAX_DST]->sin6_family == AF_INET6
               && sa_tab[RTAX_GATEWAY]->sin6_family == AF_INET6)
            {
                address = [self formatIPV6Address:((struct sockaddr_in6 *)(sa_tab[RTAX_GATEWAY]))->sin6_addr];
                //                NSLog(@"IPV6address%@", address);
                break;
            }
        }
        free(buf);
    }
    
    return address;
}

+(NSString *)getGatewayIPAddress{
    NSString *address = nil;
    
    NSString *gatewayIPv4 = [self getGatewayIPv4Address];
//    NSString *gatewayIPv6 = [self getGatewayIPv6Address];
    
//    if (gatewayIPv6 != nil) {
//        address = gatewayIPv6;
//    }else{
        address = gatewayIPv4;
//    }
    
    return address;
}

+ (NSArray *)getDNSsWithDomain:(NSString *)hostName{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *IPDNSs = [self getDNSWithHostName:hostName];
    if (IPDNSs && IPDNSs.count > 0) {
        [result addObjectsFromArray:IPDNSs];
    }
    
    return [NSArray arrayWithArray:result];
}


+ (NSArray *)getDNSWithHostName:(NSString *)hostName
{
    const char *hostN = [hostName UTF8String];
    Boolean result = false;
    Boolean bResolved = false;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    
    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, hostN, kCFStringEncodingASCII);
    
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result == true) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    bResolved = result;
    NSMutableArray *ipAddresses = [NSMutableArray array];
    if(bResolved)
    {
        struct sockaddr_in* remoteAddr;
        
        for(int i = 0; i < CFArrayGetCount(addresses); i++)
        {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            
            if(remoteAddr != NULL)
            {
                //获取IP地址
                const char *strIP41 = inet_ntoa(remoteAddr->sin_addr);
                NSString *strDNS =[NSString stringWithCString:strIP41 encoding:NSASCIIStringEncoding];
                [ipAddresses addObject:strDNS];
            }
        }
    }
    CFRelease(hostNameRef);
    if (hostRef) {
        CFRelease(hostRef);
    }
    
    return [NSArray arrayWithArray:ipAddresses];
}

+(PPSNetWorkType)getNetworkTypeFromStatusBar{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dateNetworkItemView = nil;
    for (id subView in subviews) {
        if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dateNetworkItemView = subView;
            break;
        }
    }
    PPSNetWorkType nettype = PPSNetWorkTypeNone;
    NSNumber *num = [dateNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return nettype;
}

//+(PPSNetWorkType)getNetworkTypeFromStatusBar{
//
//}

+(NSString *)currentNetInfo{
    NSString *returnName = nil;
    
    PPSNetWorkType type = [self getNetworkTypeFromStatusBar];
    
    if (type == PPSNetWorkTypeWiFi) {
        returnName = @"WiFi";
        return returnName;
    }
    
    NSString *carrierName = nil;
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if (carrier != NULL) {
        NSArray *chinaMobileMics = @[@(0),@(2),@(7)];
        NSArray *chinaTelecomMics = @[@(3),@(5),@(11)];
        NSArray *chinaUnicomMics = @[@(1),@(6)];
        NSString *str = [carrier mobileNetworkCode];
        
        NSNumber *mobileNetworkCode = [NSNumber numberWithInt:str.intValue];
        if ([chinaMobileMics containsObject:mobileNetworkCode]) {
            carrierName = @"China_Mobile";
        }else if ([chinaTelecomMics containsObject:mobileNetworkCode]) {
            carrierName = @"China_Telecom";
        }else if ([chinaUnicomMics containsObject:mobileNetworkCode]) {
            carrierName = @"China_Unicom";
        }
    }else{
        carrierName = @"unknown";
    }
    
    switch (type) {
        case PPSNetWorkType2G:
            returnName = [NSString stringWithFormat:@"%@_%@",carrierName,@"2G"];
            break;
        case PPSNetWorkType3G:
            returnName = [NSString stringWithFormat:@"%@_%@",carrierName,@"3G"];
            break;
        case PPSNetWorkType4G:
            returnName = [NSString stringWithFormat:@"%@_%@",carrierName,@"4G"];
            break;
        case PPSNetWorkType5G:
            returnName = [NSString stringWithFormat:@"%@_%@",carrierName,@"5G"];
            break;
        case PPSNetWorkTypeNone:
            returnName = [NSString stringWithFormat:@"%@_%@",carrierName,@"unknown"];
            break;
        
        default:
            returnName = [NSString stringWithFormat:@"%@_%@",carrierName,@"unknown"];
            break;
    }
    
    return returnName;
}

@end
