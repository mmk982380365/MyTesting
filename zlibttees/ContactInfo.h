//
//  ContactInfo.h
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject

@property (nonatomic, copy) NSString *familyName;

@property (nonatomic, copy) NSString *givenName;

@property (nonatomic, copy) NSArray *phoneNumbers;

@property (nonatomic, copy) NSArray *emailAddresses;

@property (nonatomic, copy) NSString *organizationName;

@property (nonatomic, strong) NSData *imageData;

@end
