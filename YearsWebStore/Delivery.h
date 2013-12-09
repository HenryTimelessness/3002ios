//
//  Delivery.h
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deliverable.h"

@interface Delivery : NSObject

@property (strong, atomic) NSString *ID;
@property (strong, atomic) NSString *DeliveryDate;
@property (strong, atomic) NSString *ReceivedDate;
@property (strong, atomic) NSString *Status;

- (Delivery *)initWithID:(NSString *)ID deliveryDate:(NSString *)deliveryDate receivedDate:(NSString *)receivedDate status:(NSString *)status;
- (Delivery *)initWithJSONString:(NSString *)jsonStringForDelivery;


@end
