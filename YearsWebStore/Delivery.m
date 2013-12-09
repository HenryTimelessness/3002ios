//
//  Delivery.m
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "Delivery.h"

@interface Delivery()

@end

@implementation Delivery


- (Delivery *)initWithID:(NSString *)ID deliveryDate:(NSString *)deliveryDate receivedDate:(NSString *)receivedDate status:(NSString *)status {
    self = [super init];
    _ID = ID;
    _DeliveryDate = deliveryDate;
    _ReceivedDate = receivedDate;
    _Status = status;
    return self;
}
- (Delivery *)initWithJSONString:(NSString *)jsonStringForDelivery {
    self = [super init];
    return self;
}

@end
