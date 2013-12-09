//
//  Shop.m
//  YearsWebStore
//
//  Created by Henry Chua on 9/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "Shop.h"

@implementation Shop
- (Shop *)initWithID:(NSString *)ID address:(NSString *)address IPAddress:(NSString *)IPAddress port:(NSString *)port {
    self = [super init];
    _ID = ID;
    _Address = address;
    _IPAddress = IPAddress;
    _Port = port;
    return self;
}
- (Shop *)initWithJSONString:(NSString *)jsonStringForShop {
    self = [super init];
    
    return self;
}
@end
