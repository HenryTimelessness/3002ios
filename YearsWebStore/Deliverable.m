//
//  Deliverable.m
//  YearsWebStore
//
//  Created by Henry Chua on 8/12/13.
//  Copyright (c) 2013 Henry Chua. All rights reserved.
//

#import "Deliverable.h"

@interface Deliverable ()

@end

@implementation Deliverable

- (Deliverable *)initWithBarcode:(NSString *)barcode name:(NSString *)name manufacturer:(NSString *)manufacturer company:(NSString *)company quantity:(int)quantity quantityReceived:(int)quantityReceived deliveryID:(NSString *)deliveryID {
    self = [super init];
    self.Name = name;
    self.Barcode = barcode;
    self.Manufacturer = manufacturer;
    self.Company = company;
    self.quantity = quantity;
    self.quantityReceived = quantityReceived;
    return self;
}

- (Deliverable *)initWithJSONString:(NSString *)jsonStringForDeliverable {
    self = [super init];
    @try {
        NSDictionary *jsonDict =
        [NSJSONSerialization JSONObjectWithData: [jsonStringForDeliverable dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: Nil];
        
    }
    @catch (NSException *ex) {
        NSLog(@"Error occured while trying to parse json string: %@", [ex description]);
    }
    return self;
}

@end
