//
//  Shop.h
//  YearsWebStore
//
//  Created by Henry Chua on 9/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
@property (strong, atomic) NSString *ID;
@property (strong, atomic) NSString *Address;
@property (strong, atomic) NSString *IPAddress;
@property (strong, atomic) NSString *Port;
@property (strong, atomic) NSString *Status;

- (Shop *)initWithID:(NSString *)ID address:(NSString *)address IPAddress:(NSString *)IPAddress port:(NSString *)port;
- (Shop *)initWithJSONString:(NSString *)jsonStringForShop;
@end
