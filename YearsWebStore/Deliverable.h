//
//  Deliverable.h
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deliverable : NSObject

@property (strong, atomic) NSString *Name;
@property (strong, atomic) NSString *Barcode;
@property (strong, atomic) NSString *Manufacturer;
@property (strong, atomic) NSString *Company;
@property (assign, atomic) int quantity;
@property (assign, atomic) int quantityReceived;
@property (strong, atomic) NSString *status;
@property (strong, atomic) NSString *DeliveryID;

- (Deliverable *)initWithBarcode:(NSString *)barcode name:(NSString *)name manufacturer:(NSString *)manufacturer company:(NSString *)company quantity:(int)quantity quantityReceived:(int)quantityReceived deliveryID:(NSString *)deliveryID;

- (Deliverable *)initWithJSONString:(NSString *)jsonStringForDeliverable;
@end
